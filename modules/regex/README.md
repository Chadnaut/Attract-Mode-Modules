# Regex

> Regular Expression handler  
> Version 0.1.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("regex");

local matches = Regex("Cat Dog").match_all("([A-Z])([a-z]+)");
// matches == [["Cat", "C", "at"], ["Dog", "D", "og"]]
```

![Example](example.png)\
*Example of match_all groups.*

## Functions

- `Regex(str)` - Apply regular expression to the passed string
  - `test(pattern)` - Return true if pattern matches
  - `search(pattern, start = 0)` - Return index of pattern in value, or -1 if none
  - `match(pattern)` - Return array of full-matches
  - `match_all(pattern)` - Return array of group matches
  - `replace(pattern, replace)` - Replace first matching pattern
  - `replace_all(pattern, replace)` - Replace all matching patterns

Replace strings can use `$0` placeholders to insert match groups.