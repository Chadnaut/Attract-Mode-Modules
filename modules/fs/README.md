# FileSystem

> File reading and writing  
> Version 0.9.0  
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

- `::fs.open(path, mode = "r")` *FileHander* - Returns a FileHander.
- `::fs.copy(from, to, overwrite?)` *bool* - Copy file.
- `::fs.move(from, to, overwrite?)` *bool* - Move file.
- `::fs.unlink(path)` *bool* - Delete file.
- `::fs.rename(from, to)` *bool* - Rename file.
- `::fs.exists(path)` *bool* - Return true if path exists.
- `::fs.file_exists(path)` *bool* - Return true if file exists.
- `::fs.directory_exists(path)` *bool* - Return true if directory exists.
- `::fs.crc32(path)` *int* - Return unsigned CRC32 of file.
- `::fs.readdir(path, absolute = false)` *[string]* - Returns a list of items in path.
- `::fs.join(...)` *string* - Joins passed arguments using slash `/` delimiter.
- `::fs.add_trailing_slash(path)` *string* - Ensure path has trailing slash.
- `::fs.remove_trailing_slash(path)` *string* - Ensure path has no trailing.

Note that functions will *throw* errors on invalid actions, such as copying a file that doesn't exist.

### Shortcuts

These shortcuts are provided to make it easier to perform simple tasks.

- `::fs.file_size(path)` *int* - Shortcut for `FileHander.len`.
- `::fs.read(path)` *string* - Shortcut for `FileHander.read`.
- `::fs.read_lines(path)` *[string]* - Shortcut for `FileHander.read_lines`.
- `::fs.read_csv(path)` *[[string]]* - Shortcut for `FileHander.read_csv`.
- `::fs.read_pairs(path)` *[[string]]* - Shortcut for `FileHander.read_pairs`.
- `::fs.write(path, string)` - Shortcut for `FileHander.write`.
- `::fs.write_lines(path, lines)` - Shortcut for `FileHander.write_lines`.
- `::fs.write_csv(path, csv)` - Shortcut for `FileHander.write_csv`.
- `::fs.write_pairs(path, pairs)` - Shortcut for `FileHander.write_pairs`.

## Modes

|Flag|Name|Read|Write|Create|Truncate|Append|
|-|-|-|-|-|-|-|
|`r`|Read|&#x2714;|&#x274C;|&#x274C;|&#x274C;|&#x274C;|
|`r+`|Read+|&#x2714;|&#x2714;|&#x274C;|&#x274C;|&#x274C;|
|`w`|Write|&#x274C;|&#x2714;|&#x2714;|&#x2714;|&#x274C;|
|`w+`|Write+|&#x274C;|&#x2714;|&#x2714;|&#x2714;|&#x274C;|
|`a`|Append|&#x274C;|&#x2714;|&#x2714;|&#x274C;|&#x2714;|
|`a+`|Append+|&#x2714;|&#x2714;|&#x2714;|&#x274C;|&#x2714;|
|`b`|Binary|*|*|*|*|*|

- Flags that `create` files will do so on `open()`.
- Calling methods on a `FileHandler` that does not support it will return `null` and/or print an error in `last_run.log`.
- `r+` will begin writing at the head of the file, use `a` mode, or `end()` to move the pointer.
- Add `b` to any flag (ie: `rb`, `wb`) to operate in binary mode.

## FileHandler

The FileHander should be used to process file data one line at a time, which is more efficient than reading the entire file and looping through the results.

- `read_line()` *string* - Return next line in file, or null if none.
- `read_lines()` *[string]* - Return all lines as array.
- `read()` *string* - Return entire file as string.
- `write_line(string)` - Write string to file with new line after.
- `write_lines([string])` - Write array of strings to file with new lines after.
- `write(string)` - Write string to entire file.
- `read_csv_line(delim = ";")` *[string]* - Return next csv line as array, or null if none.
- `read_csv(delim = ";")` *[[string]]* - Return all csv lines as an array of arrays.
- `write_csv_line(row, delim = ";")` - Write delimited values to file.
- `write_csv(csv, delim = ";")` - Write array of delimited values to file.
- `read_pairs_line()` *[string]* - Return next pairs line as array, or null if none.
- `read_pairs()` *[[string]]* - Return all pairs lines as an array of arrays.
- `write_pairs_line(row)` - Write pair values to file.
- `write_pairs(pairs)` - Write array of pair values to file.
- `close()` - Closes the file, and allow other handlers to open it.
- `len()` *int* - Return length of file.
- `exists()` *bool* - Return true if file exists.
- `rewind()` - Place pointer at start of file.
- `end()` - Place pointer at end of file.
- `seek(offset, origin?)` - Move pointer within file.
  - `offset` - number of characters to move (NOTE: `\n` == 2 chars).
  - `origin` - offset from beginning `b`, end `e`, or current `c`.

## Further Reading

- https://medium.com/@vbabak/implementing-crc32-in-typescript-ff3453a1a9e7