# FileSystem

> File reading and writing  
> Version 0.3.0  
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

- `::fs.open(path, mode = "r")` *FileHander* - Returns a FileHander, mode = `r` read, `w` write.
- `::fs.readdir(path, absolute = false)` *[string]* - Returns an array of paths from `path`.
- `::fs.join(...)` *string* - Joins passed arguments using slash `/` delimiter.

## FileHandler (Read)

- `read()` *string* - Return entire file as string.
- `read_line()` *string* - Return next line in file, or null if none.
- `read_lines()` *[string]* - Return all lines as array.
- `exists()` *bool* - Return true if file exists.
- `len()` *int* - Return length of file (null if no file).
- `close()` - Closes file.
- `rewind()` - Place read pointer at start of file.

## FileHandler (Write)

- `write(string)` - Write string to file.
- `write_line(string)` - Write string to file with new line after.
- `write_lines([string])` - Write array of strings to file.
- `exists()` *bool* - Return true if file exists.
- `len()` *int* - Return length of file (null if no file).
- `close()` - Closes file.
- `rewind()` - Place write pointer at start of file.

## Differences

AM already comes with a file handling module, how is this any different?

- Reads whitespace as-is (does not automatically trim it)
- Can check the file `exists()`
- Can get the file `len()`
- Read or write lines from arrays
- Read entire file into string
- Read returns `null` to signal end-of-file