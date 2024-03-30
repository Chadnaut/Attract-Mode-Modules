# Stringify

> JSON-like value stringification  
> Version 0.1.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("stringify");

local object = {a = 1, b = 2.0, c = ["d", "e"]};
print(stringify(object) + "\n");
```

```log
{a = 1, b = 2.0, c = ["d", "e"]}
```

Pretty printing:

```cpp
print(stringify(object, "  ") + "\n");
```

```log
{
  a = 1, 
  b = 2.0, 
  c = [
    "d", 
    "e"
  ]
}
```

Pass `stringify` any value and it will convert it into a string, handy for printing to `last_run.log`.

## Function

- `stringify(value, space?)` - Returns a string.
  - `value` *any* - The value to stringify.
  - `space` *string* - (Optional) Indent for pretty-printing.
