# Retention

> Surface image persistence  
> Version 0.7.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
::fe.load_module("retention");

local s1 = ::fe.add_surface(::fe.layout.width, ::fe.layout.height);
local s2 = Retention(s1);
s2.persistence = 0.98;

local img = s1.add_artwork("snap", 0, 0, 400, 400);
img.video_flags = Vid.ImagesOnly;

::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (img.x >= ::fe.layout.width) img.x = 0; else img.x += 4;
};
```

`Retention()` returns a new surface with image persistence. Adjusting the original surface `s1` moves the object, while adjusting the new surface `s2` moves the feedback.

![Example](example.png)\
*Example of retention with rotation*

## Properties

- `persistence` *float* - Get/set strength of the image retention [0.0...1.0].
- `falloff` *float* - Get/set retention fadeout [0.0...1.0].

## About

The module adds a handful of extra elements to "exploit the one frame delay of surfaces".

1. `A` - original surface, contains artwork
2. `B` - worker surface, hidden
3. `C` - clone of `A` within `B`
4. `D` - clone of `B` within `A`, shader uses `A` texture

```
----------    ----------
|A       |    |B       |
| D(B+A) |    |  C(A)  |
|        |    |        |
----------    ----------
```

The net result is that `B` is still showing the previous frame when used by `D`.

## Further Reading

- [Phosphor retention effect](http://forum.attractmode.org/index.php?topic=2496.msg17029)