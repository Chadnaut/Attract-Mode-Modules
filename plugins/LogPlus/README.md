# LogPlus

> Extended fe.log functionality  
> Version 0.5  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

- Configure > Plug-ins > LogPlus
- Enabled > Yes

```cpp
fe.log("String", true, {a = 1, b = 2.0, c = ["d", "e"]});
```

```log
"String", true, {
    a = 1, 
    b = 2.0, 
    c = [
        "d", 
        "e"
    ]
}
```

Overrides the native `fe.log()` method to accept multiple arguments, and pretty-print the results.

Use a [Log Viewer](https://marketplace.visualstudio.com/items?itemName=berublan.vscode-log-viewer) extension in VSCode to see the log update in realtime.

## Plugin Options

- `Show Time` - Add layout time to each log
- `Show Diff` - Add duration since last log to each log
- `Show Frame` - Add frame number to each log
- `Indent` - Indent size for pretty-printed objects
- `Delimiter` - Character printed between values
- `Specials` - Allow special strings to be printed without quotes

## Advanced

Limits and filters can be useful when debugging high-frequency logs.

`fe.plugin["LogPlus"]` has the following properties:
- `limit` *int* - Maximum number of messages to print
- `before` *int* - Only allow messages before time
- `after` *int* - Only allow messages after time
- `filter` *string* - Regular expression to filter messages

```cpp
fe.plugin["LogPlus"].filter = "good";
fe.log("hello");
fe.log("goodbye");

/*
"goodbye"
*/
```

## Specials

Some text appears nicer in the log file without quote marks.

- Angle brackets and braces: `<value>`, `{value}`
- Dashes used for bullet points: ` - `
- Keywords: `INFO`, `NOTICE`, `ALERT`, `DEBUG`, `ERROR`, `WARN`, `WARNING`
- Datetime: `2024-04-26T12:34:56`
- Time, diff and frame prefixes: `0:00:00.000 +00000 [00000]`

## Notes

If this plugin is disabled, `fe.log()` calls with *multiple* arguments will throw errors, ie: `fe.log(1, 2, 3)`.
