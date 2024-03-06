# Console

> Debug logging  
> Version 0.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- `stringify` - Module found in the above repo

## Quickstart

```cpp
fe.load_module("console");
::console <- Console();

::console.log("Hello", { a = 1 });

/* last_run.log
"Hello", {
    a = 1
}
*/
```

Use `::console.log(...)` in your code to print variables to `last_run.log` to assist in debugging.

Note that the AM window requires focus to update the log file.

## Advanced

```cpp
::console.filter = "good";
::console.log("hello");
::console.log("goodbye");

/* last_run.log
console.filter = "good"
"goodbye"
*/
```

- `level` *int* - Log level, 0 = NONE, 1 = ERROR, 2 = INFO, 3 = LOG/TIME
- `limit` *int* - Maximum number of messages to print
- `before` *int* - Only allow messages before elapsed time
- `after` *int* - Only allow messages after elapsed time
- `filter` *string* - Regular expression to filter messages
- `space` *string* - Stringify pretty-print space

Limits and filters can be useful when debugging high-frequency logs.
