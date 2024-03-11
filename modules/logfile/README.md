# Logfile

> Debug logging to last_run.log  
> Version 0.4 
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- `stringify` - Module found in the above repo

## Quickstart

```cpp
fe.load_module("logfile");
::logfile <- Logfile();

::logfile.log("Hello", 1, 2, 3);
::logfile.info("Info");
::logfile.error("Error");
::logfile.time("Time");

/* last_run.log
"Hello", 1, 2, 3
INFO, "Info"
WARNING, "Error"
0:00:00.123 +0123 [0000], "Time"
*/
```

Note that the AM window requires focus to update the log file.

## Filters

```cpp
::logfile.filter = "good";
::logfile.log("hello");
::logfile.log("goodbye");

/* last_run.log
console.filter = "good"
"goodbye"
*/
```

- `level` *int* - Log level, `0 = NONE, 1 = ERROR, 2 = INFO, 3 = LOG/TIME`
- `limit` *int* - Maximum number of messages to print
- `before` *int* - Only allow messages before elapsed time
- `after` *int* - Only allow messages after elapsed time
- `filter` *string* - Regular expression to filter messages
- `space` *string* - Stringify pretty-print space

Limits and filters can be useful when debugging high-frequency logs.
