fe.load_module("console");
::console <- Console({});
// ::console <- Console(); // without display

::console.time("Start");
::console.log();
::console.log("Object", { a = 1, b = 2.0, c = ["d", "e"] });
::console.info("Success");
::console.error("Failure");
::console.log("View last_run.log to see this output");
::console.log();
::console.time("Finish");
