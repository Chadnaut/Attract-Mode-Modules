# Retention

> Surface image persistance  
> Version 0.5  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("retention");

local s1 = fe.add_surface(fe.layout.width, fe.layout.height);
local s2 = Retention(s1);
s2.persistance = 0.98;

local img = s1.add_artwork("snap", 0, 0, 400, 400);
img.video_flags = Vid.ImagesOnly;
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (img.x >= fe.layout.width) img.x = 0; else img.x += 4;
};
```

`Retention()` returns a new surface with image persistance. Adjusting the original surface `s1` moves the object, while adjusting the new surface `s2` moves the feedback.

![Example](example.png)\
*Example of retention with rotation*

## Properties

- `persistance` *float* - Get/set strength of the image retention [0.0...1.0].