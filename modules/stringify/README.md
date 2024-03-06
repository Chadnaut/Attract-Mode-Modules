# Stringify

> JSON-like value stringification  
> Version 0.1  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("stringify");

local object = {a = 1, b = 2.0, c = ["d", "e"]};
print(stringify(object) + "\n");

/* last_run.log
{a = 1, b = 2.0, c = ["d", "e"]}
*/
```

Pass `stringify` any value and it will convert it into a string, handy for printing to `last_run.log`.

## Advanced

An optional second argument accepts a `space` string for pretty-printing.

```cpp
print(stringify(object, "  ") + "\n");

/* last_run.log
{
  a = 1, 
  b = 2.0, 
  c = [
    "d", 
    "e"
  ]
}
*/
```
