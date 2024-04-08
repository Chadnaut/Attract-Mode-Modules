# Sequence

> Stackable animation system  
> Coming Soon  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [ease](https://github.com/Chadnaut/Attract-Mode-Modules/blob/master/modules/ease) - module can be found in this repo

## Quickstart

```cpp
fe.load_module("sequence");

local artwork = Sequence(fe.add_artwork("snap", 0, 0, 400, 400));

artwork
    .animate(500)
        .to("x", 100) // first move here
    .animate(500)
        .to("y", 100) // then move here
    .animate(500)
        .to("x", 0) // finally move here
        .to("y", 0);
```

## Coming Soon...

- Code
- Examples
- Documentation
