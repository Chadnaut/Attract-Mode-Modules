# LogPlus

> Extended logging functionality  
> Version 0.6.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [stringify](https://github.com/Chadnaut/Attract-Mode-Modules/blob/master/modules/stringify) - module can be found in this repo

## Quickstart

```cpp
fe.load_module("logplus");

::logplus.show_time = true;
::logplus.show_frame = true;

::logplus("INFO", "ALERT", "WARNING");
::logplus({ a = 1, b = 2.0, c = ["d", "e"] });
```

![Example](example.png)\
*Example log as seen in VSCode*

## Properties

- `show_time` *bool* - Add layout time to each log `0:00:00.000`
- `show_diff` *bool* - Add duration since last log to each log `+00000`
- `show_frame` *bool* - Add frame number to each log `[00000]`
- `show_specials` *bool* - Allow special strings to be printed without quotes
- `indent` *string* - Indent string for pretty-printed objects
- `delimiter` *string* - Character printed between values
- `limit` *int* - Maximum number of messages to print
- `before` *int* - Only allow messages before time
- `after` *int* - Only allow messages after time
- `filter` *string* - Regular expression to filter messages

Limits and filters can be useful when debugging high-frequency logs.

```cpp
::logplus.filter = "good";
::logplus("hello");
::logplus("goodbye");

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

- Attract-Mode Plus 3.0.8 (and lower) must have focus to update the log file.
- Later versions update the log file in the background.
- Use a [Log Viewer](https://marketplace.visualstudio.com/items?itemName=berublan.vscode-log-viewer) extension in VSCode to see log updates in realtime.
