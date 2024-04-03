fe.do_nut(fe.module_dir + "utils.nut");

fe.load_module("stringify");
fe.load_module("console");

class UnitTest {

    console = ::Console();

    _prop = null;
    _prop_defaults = {
        catch_error = true,
        warmup_frames = 10,
        summary = false,
        theme = [
            [[255, 255, 255], [0,   0, 0]],
            [[0,   255,   0], [0,   0, 0]],
            [[255,   0,   0], [200, 0, 0]],
        ],
    };

    _suites = [];           // stores all suites
    _suite_index = 0;       // current suite index
    _suite = null;          // current suite

    _spec_index = 0;        // current spec index
    _spec = null;           // current spec

    _expectation = null;    // expected value
    _not = null;            // invert success

    _bench = false;         // true if benchmarking
    _duration = 0;          // time to run each spec during bench

    _running = false;       // true if running
    _start = 0;             // start time
    _frame = 0;             // current frame
    _wait = 0;              // current wait frames

    // =============================================

    constructor() {
        _prop = clone _prop_defaults;
        fe.add_ticks_callback(this, "on_tick");
    }

    // =============================================

    function _get(idx) {
        if (idx in _prop) return _prop[idx];
        throw null;
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; return;
        throw null;
    }

    // =============================================
    // Configuring

    // Add a suite
    function describe(title, callback) {     add_suite(title, callback, false); }
    function fdescribe(title, callback) {    add_suite(title, callback, true); }
    function xdescribe(title, callback) {}
    function add_suite(title, callback, focus) {
        local suite = {
            title = title,      // name of suite
            callback = callback.bindenv(this), // suite specs
            focus = focus,      // true runs only this, false excludes this, null runs all
            specs = [],         // populated when callback run
        };

        if (focus) {
            _suites = [suite];
        } else if (!_suites.len() || !_suites[0].focus) {
            _suites.push(suite);
        }
    }

    // Add a spec to the current suite - called during suite callback
    function it(title, callback) {   add_spec(title, callback, false); }
    function fit(title, callback) {  add_spec(title, callback, true); }
    function xit(title, callback) {}
    function add_spec(title, callback, focus) {
        local spec = {
            title = title,      // name of spec
            callback = callback.bindenv(this), // spec expects tests
            focus = focus,      // true runs only this, false excludes this, null runs all
            errors = [],        // callback errors
            response = null,    // callback response
            duration = 0,       // callback runtime
            calls = 0,          // callback run count
            wait = 0,           // frames wait after callback
            matchers = 0,       // number of matchers in callback
        };

        if (focus) {
            _suites = [_suite];
            _suite.specs = [spec];
        } else if (!_suite.specs.len() || !_suite.specs[0].focus) {
            _suite.specs.push(spec);
        }
    }

    // Set expected response - called during spec
    function expect(expectation) {
        _expectation = expectation;
        _not = false;
        return this;
    }

    // Invert response success condition
    function not() {
        _not = true;
        return this;
    }

    // Matchers for spec tests
    function toBe(expected) {                            result(_expectation == expected); }
    function toBeTrue() {                                result(_expectation == true); }
    function toBeTruthy() {                              result(!!_expectation); }
    function toBeFalse() {                               result(_expectation == false); }
    function toBeFalsy() {                               result(!_expectation); }
    function toBeNull() {                                result(_expectation == null); }
    function toBeGreaterThan(expected) {                 result(_expectation > expected); }
    function toBeGreaterThanOrEqual(expected) {          result(_expectation >= expected); }
    function toBeLessThan(expected) {                    result(_expectation < expected); }
    function toBeLessThanOrEqual(expected) {             result(_expectation <= expected); }
    function toBeCloseTo(expected, delta = 0.0001) {     result(close_to(_expectation, expected, delta)); }
    function toEqual(expected) {                         result(close_to(_expectation, expected, 0)); }
    function toMatch(expected) {                         result(regex_test(_expectation, expected)); }
    function toContain(expected) {                       result(_expectation.find(expected) != null); }
    function toContainEqual(expected) {                  result(contains_equal(_expectation, expected)); }
    function toContainCloseTo(expected, delta = 0.0001) {result(contains_close_to(_expectation, expected)); }
    function toHaveLength(expected) {                    result(_expectation.len() == expected); }
    function toBeInstanceOf(expected) {                  result(typeof _expectation == expected); }

    // Assymetric matchers
    function arrayContaining(expected) {
        return array_contains(_expectation, expected) ? _expectation : expected;
    }

    // Flow
    function wait(frames = 1) { _spec.wait = frames; }

    // =============================================
    // Testing

    // Start tests
    function test() {
        _bench = false;
        init_specs();
        start(0);
    }

    // Start benchmark
    function benchmark(duration = 1000) {
        _bench = true;
        init_specs();
        if (valid_benchmark_specs()) start(duration);
    }

    // Remove all suites
    function clear() {
        _suites.clear();
    }

    // =============================================
    // Starting

    // Check specs equal for benchmarks
    function valid_benchmark_specs() {
        start(0);
        while (_running) process();
        foreach (suite in _suites) {
            local response = suite.specs.len() ? suite.specs[0].response : null;
            foreach (spec in suite.specs)
                if (!close_to(spec.response, response, 0.0001))
                    spec.errors.push("spec " + ::stringify(spec.response) + " does not equal " + ::stringify(response));
        }
        if (has_errors()) {
            refresh_console();
            print_report();
            return false;
        }
        return true;
    }

    // True if any spec has an error
    function has_errors() {
        foreach (suite in _suites) foreach (spec in suite.specs) if (spec.errors.len()) return true;
        return false;
    }

    // Populate suite specs
    function init_specs() {
        foreach (suite in _suites) {
            _suite = suite;
            suite.specs.clear();
            suite.callback();
            if (suite.specs.len() && suite.specs[0].focus) return;
        }
    }

    // Set flags to activate on_tick test run
    function start(duration) {
        _start = fe.layout.time;
        _running = true;
        _duration = duration;
        _suite_index = 0;
        _suite = null;
        foreach (suite in _suites) foreach (spec in suite.specs) {
            spec.errors.clear();
            spec.matchers = 0;
            spec.calls = 0;
            spec.response = null;
        }
    }

    // =============================================
    // Running

    // Processing on tick allows UI time to draw
    function on_tick(ttime) {
        _frame++;
        local running = _running;
        if (_frame >= warmup_frames) process();
        if (running) {
            refresh_console();
            if (!_running) print_report();
        }
    }

    // Run the suite specs one after the other
    function process() {
        if (!_running) return;

        if (_wait > 0) _wait--;
        if (_wait > 0) return;

        if (_suite_index >= _suites.len()) {
            _running = false;
            return;
        }

        if (!_suite) {
            _suite = _suites[_suite_index];
            _spec_index = 0;
            _spec = null;
        }

        if (!_spec && _spec_index < _suite.specs.len()) {
            _spec = _suite.specs[_spec_index];
        }

        if (_spec) {
            run_spec();
            _wait = _spec.wait;
            _spec_index++;
            _spec = null;
        }

        if (_spec_index >= _suite.specs.len()) {
            _suite_index++;
            _suite = null;
            _spec_index = 0;
            _spec = null;
        }

        // immediately process the next item (unless benchmarking or waiting)
        if (!_bench && _wait <= 0) process();
    }

    // Run the current spec callback
    function run_spec() {
        collectgarbage();
        local run_duration = _duration > 0 ? _duration : -1;
        local duration = 0;
        local calls = 0;
        local callback = _spec.callback;
        local response = null;
        local start_time = fe.layout.time;

        // Run callback as many times as possible during duration
        try {
            while (!calls || duration < run_duration) {
                calls++;
                response = callback();
                duration = fe.layout.time - start_time;
            }
        } catch (error) {
            // stack info cannot reach error
            _spec.errors.push(::stringify(_expectation) + " " + error);
            // run callback again to halt the layout and trace
            if (!catch_error) callback();
        }

        _spec.duration = duration;
        _spec.calls = calls;
        _spec.matchers /= calls || 1;
        _spec.response = response;
    }

    // Matchers add an error message if unsuccessful
    function result(success) {
        _spec.matchers++;
        if (_not == success) {
            local info = getstackinfos(2); // matcher must be class function
            _spec.errors.push(
                ::stringify(_expectation)
                + (_not ? " not" : "")
                + (error ? " " + info.func : "")
                + ("expected" in info.locals ? " " + ::stringify(info.locals.expected) : "")
            );
        }
        return this;
    }

    // =============================================
    // Reporting

    // Update console message to match current state
    function refresh_console() {
        console.clear();

        foreach (i, suite in _suites) {
            local complete = (i < _suite_index);
            local current = (i == _suite_index);
            local pass = 0;
            local fail = 0;

            // tally passes and fails
            foreach (spec in suite.specs) {
                local error = !!spec.errors.len();
                pass += (!error && !!spec.calls) ? 1 : 0;
                fail += error ? 1 : 0;
            }

            // create message
            local success = complete && !fail;
            local message = suite.title + " (" + pass + "/" + suite.specs.len() + ")" + (current ? " <" : "");

            // add bench result
            if (_bench && success) {
                if (suite.specs.len()) {
                    local max = 0;
                    local best = { calls = 0 };
                    local next = { calls = 0 };
                    foreach (spec in suite.specs) if (spec.calls > best.calls) best = spec;
                    foreach (spec in suite.specs) if (spec.calls > next.calls && spec != best) next = spec;
                    message += " = " + best.title + " +" + floor((best.calls - next.calls) * 100.0 / best.calls) + "%";
                } else {
                    message += " no specs";
                }
            }

            // print to console
            local cols = theme[!complete ? 0 : success ? 1 : 2];
            console.print(message, cols[0], cols[1]);
        }
    }

    // Print results to last_run.log
    function print_report() {
        print("\n" + (_bench ? "Benchmark" : "Test") + (summary ? " Summary" : " Results") + "\n\n");

        local end_time = fe.layout.time;
        local total_error = has_errors();
        local total_specs = 0;
        local total_fails = 0;
        if (!_bench && summary && !total_error) print("INFO - All suites passed!\n");

        foreach (suite in _suites) {
            local pass = 0;
            local fail = 0;
            foreach (spec in suite.specs) {
                local error = !!spec.errors.len();
                if (!error && !!spec.calls) pass++;
                if (error) { fail++; total_fails++; }
                total_specs++;
            }

            // Suite title
            if (_bench || (!summary || !!fail)) print(@"""" + suite.title + @"""" + "\n");

            // Sort by benchmark results
            local max_calls = 0;
            local specs = clone suite.specs;
            if (_bench && !total_error) {
                foreach (spec in suite.specs) if (spec.calls > max_calls) max_calls = spec.calls;
                specs.sort(@(a, b) b.calls <=> a.calls);
            }

            if (!specs.len()) {
                print("  WARN no specs\n");
            }

            foreach (i, spec in specs) {
                if (spec.errors.len()) {
                    // Spec errors
                    print("  WARN " + spec.title + "\n");
                    foreach (error in spec.errors) print("    " + error + "\n");
                } else {
                    if (_bench && !total_error) {
                        // Bench result
                        if (!summary || (i == 0)) {
                            local percent = ("  " + ceil(spec.calls * 100.0 / max_calls)).slice(-3);
                            print("  " + percent + "% " + spec.title + " (" + spec.calls + ")\n");
                        }
                    } else if (!summary || total_error) {
                        // Passed
                        print("  INFO " + spec.title + "\n");
                    }
                }
            }
        }

        // Footer
        print("\n" + _suites.len() + " suites, " + total_specs + " specs, " + total_fails + " failures\n");
        if (_bench) print("Benchmark for " + (_duration / 1000.0) + " seconds\n");
        print("Finished in " + ((end_time - _start) / 1000.0) + " seconds\n\n");
    }
}
