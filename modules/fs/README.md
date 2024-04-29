# FileSystem

> File reading and writing  
> Version 0.5.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("fs");

// read a file line-by-line
local file = ::fs.open(FeConfigDirectory + "attract.cfg", "r");
local line = null;
while (line = file.read_line()) print(line + "\n");

// read a dir
local dir = ::fs.readdir(FeConfigDirectory, true);
foreach (d in dir) print(d + "\n")
```

![Example](example.png)\
*Example readdir results*

## Functions

- `::fs.open(path, mode = "r")` *FileHander* - Returns a FileHander
- `::fs.readdir(path, absolute = false)` *[string]* - Returns an array of paths from `path`.
- `::fs.join(...)` *string* - Joins passed arguments using slash `/` delimiter.
- `::fs.exists(path)` *bool* - Return true if path exists
- `::fs.file_exists(path)` *bool* - Return true if file exists
- `::fs.directory_exists(path)` *bool* - Return true if directory exists

## Modes

|Flag|Name|Read|Write|Create|Truncate|Append|
|-|-|-|-|-|-|-|
|`r`|Read|&#x2714;|&#x274C;|&#x274C;|&#x274C;|&#x274C;|
|`r+`|Read+|&#x2714;|&#x2714;|&#x274C;|&#x274C;|&#x274C;|
|`w`|Write|&#x274C;|&#x2714;|&#x2714;|&#x2714;|&#x274C;|
|`w+`|Write+|&#x274C;|&#x2714;|&#x2714;|&#x2714;|&#x274C;|
|`a`|Append|&#x274C;|&#x2714;|&#x2714;|&#x274C;|&#x2714;|
|`a+`|Append+|&#x2714;|&#x2714;|&#x2714;|&#x274C;|&#x2714;|

- Flags that `create` files will do so on `open()`.
- Calling methods on a `FileHandler` that does not support it will return `null` and/or print an error in `last_run.log`.
- `r+` will begin writing at the head of the file, use `a` mode, or `end()` to move the pointer.

## FileHandler

- `read()` *string* - Return entire file as string.
- `read_line()` *string* - Return next line in file, or null if none.
- `read_lines()` *[string]* - Return all lines as array.
- `read_csv_line(delim = ";")` *[string]* - Return next csv line as array in file, or null if none.
- `read_csv_lines(delim = ";")` *[[string]]* - Return all csv lines as array.
- `write(string)` - Write string to file.
- `write_line(string)` - Write string to file with new line after.
- `write_lines([string])` - Write array of strings to file.
- `exists()` *bool* - Return true if file exists.
- `len()` *int* - Return length of file (null if no file).
- `close()` - Closes file.
- `rewind()` - Place pointer at start of file.
- `end()` - Place pointer at end of file.
- `seek(offset, origin?)` - Move pointer within file
  - `offset` - character to move, '\n' == 2 chars
  - `origin` - start from beginning, end, current: `'b', 'e', 'c'`
