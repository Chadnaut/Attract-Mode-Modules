# UnitTest

> Testing and benchmarking  
> Version 1.1.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [console](https://github.com/Chadnaut/Attract-Mode-Modules/blob/master/modules/console) - module can be found in this repo
- [stringify](https://github.com/Chadnaut/Attract-Mode-Modules/blob/master/modules/stringify) - module can be found in this repo


## Quickstart

```cpp
fe.load_module("unittest");

local ut <- UnitTest();
::describe <- ut.describe.bindenv(ut);

describe("MyTest", function() {
    it("should pass", function() {
        expect(1).toBeTruthy();
    });
    it("should fail", function() {
        expect(0).toBeTruthy();
    });
});

ut.test();
```

The syntax mostly follows popular testing frameworks. A summary will be displayed onscreen, with a detailed report printed to `last_run.log`.

```log
"MyTest"
  ✔️ should be truthy
  ❌ should fail
    0 toBeTruthy

1 suites, 2 specs, 1 failures
Finished in 0.16 seconds
```

![Example](example.png)\
*Example console output*

## Test

- `Suites` are groups of related `Specs`.
- `Specs` are individual tests that have a number of `Expectations`.
- `Expectations` use `Matchers` to test function responses.
- All `Matchers` must pass for the `Spec` to pass.
- All `Specs` must pass for the `Suite` to pass.
- On completion a report is printed to `last_run.log`.
- `Specs` with failed `Expectations` are flagged.

## Benchmark

- `Suites` are groups of related `Specs`.
- `Specs` are methods to benchmark, each must return the same result.
- `Suites` are run repeatedly for a set duration.
- On completion a report is printed to `last_run.log`.
- `Specs` are ranked most-to-least call-count.

Note that `wait()` cannot be used in benchmarks, and results will be dependant on system load at run-time.

## Properties

- `catch_error` *bool* - If false throw errors on code problems.
- `warmup_frames` *int* - Frames to wait before starting.
- `summary` *bool* - If true print summary instead of full report.

## Functions

- `describe(title, callback)` - Add a suite for testing.
  - `title` *string* - Name of the suite.
  - `callback` *function* - Function containing specs.
- `fdescribe(title, callback)` - Run this suite only.
- `xdescribe(title, callback)` - Do not run this suite.
- `test()` - Run all suites and report.
- `benchmark(duration?)` - Run each spec for duration and report most-run spec.

The `describe` methods should be bound to globals so suites can be defined over multiple `.nut` files.

```cpp
local ut = UnitTest();
::describe <- ut.describe.bindenv(ut);
::fdescribe <- ut.fdescribe.bindenv(ut);
::xdescribe <- ut.xdescribe.bindenv(ut);
```

## Suite Functions

- `it(title, callback)` - Add a spec to the suite.
  - `title` *string* - Name of the spec.
  - `callback` *function* - Function containing tests.
- `before(title, callback)` - Execute code before a spec.
  - `title` *string* - Name of the action.
  - `callback` *function* - Function containing setup.

## Spec Functions

- `expect(value)` - Set the value to match.
- `not()` - Invert the matcher response.

## Matcher Functions

- `toBe(expected)` - Value to `==` expected.
- `toBeTrue()` - Value to be `true`.
- `toBeTruthy()` - Value to be truthy.
- `toBeFalse()` - Value to be `false`.
- `toBeFalsy()` - Value to be falsey.
- `toBeNull()` - Value to be `null`.
- `toBeGreaterThan(expected)` - Value (*number*) to be `>` expected.
- `toBeGreaterThanOrEqual(expected)` - Value (*number*) to be `>=` expected.
- `toBeLessThan(expected)` - Value (*number*) to be `<` expected.
- `toBeLessThanOrEqual(expected)` - Value (*number*) to be `<=` expected.
- `toBeCloseTo(expected, delta)` - Value (*number*) to be within delta of expected.
- `toEqual(expected)` - Value to deep-match expected.
- `toMatch(expected)` - Value (*string*) to regex match expected pattern.
- `toContain(expected)` - Value (array, string) to contain expected.
- `toContainEqual(expected)` - Value (*array*) to contain item equal to expected.
- `toContainCloseTo(expected, delta)` - Value (*any*) to contain items close to expected.
- `toHaveLength(expected)` - Value `.len()` to be expected.
- `toBeInstanceOf(expected)` - Value to be instance of expected.

Note - `CloseTo` matchers are useful when handling `float` values, ie: `0.1 + 0.2 != 0.3`.

## Assymetric Matchers

- `arrayContaining(expected)` - Matches array contents
```cpp
expect(["a", "b", "c"]).toEqual(arrayContaining(["a", "b"]));
```

## Flow

- `wait(frames?)` - Waits a number of frames before running the next spec, used to test asynchronous events such as signals.
