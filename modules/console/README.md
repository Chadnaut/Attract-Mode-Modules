# Console

> Debug logging  
> Version 0.3  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- `stringify` - Module found in the above repo

## Quickstart

```cpp
fe.load_module("console");
::console <- Console();

::console.log("Hello", 1, 2, 3);
::console.info("Info");
::console.error("Error");
::console.time("Time");

/* last_run.log
"Hello", 1, 2, 3
INFO, "Info"
WARNING, "Error"
0:00:00.123 +0123 [0000], "Time"
*/
```

Use `::console.log(...)` in your code to print variables to `last_run.log` to assist in debugging.

Note that the AM window requires focus to update the log file.

## Filters

```cpp
::console.filter = "good";
::console.log("hello");
::console.log("goodbye");

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

## Advanced

If a config object is passed to `Console()` it will draw an onscreen element.

```cpp
fe.load_module("console");
::console <- Console({
    toggle = "custom2",
});

::console.log("white");
::console.info("green");
::console.error("red");
```

`options` *object* (optional)
- `x` *int* - x position of console
- `y` *int* - y position of console
- `width` *int* - width of console
- `height` *int* - height of console
- `char_size` *int* - size of console font
- `margin` *int* - margin for console font
- `toggle` *string* - signal to show/hide console
- `zorder` *int* - zorder for console
- `log_file` *bool* - print messages to `last_run.log`
