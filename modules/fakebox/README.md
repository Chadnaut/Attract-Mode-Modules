# FakeBox

> A fake 3D spinning box.  
> Version 0.2.0 2025-12-05  
> Chadnaut 2025  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("fakebox");

local box = FakeBox(200, 200, 400, 400)
box.rotation = 45

box.art_front = fe.add_artwork("snap")
box.art_right = fe.add_artwork("snap")
box.art_back = fe.add_artwork("snap")
box.art_left = fe.add_artwork("snap")
box.art_top = fe.add_artwork("snap")
box.art_bottom = fe.add_artwork("snap")
```

Create a `FakeBox` and assign Images to each of its sides.

![Example](example.png)\
_A FakeBox using Sega Genesis box artwork_

## Constructor

```cpp
local box = FakeBox(x, y, width, height)
```

## Properties

-   `x` _float_ - The x position of the box centre.
-   `y` _float_ - The y position of the box centre.
-   `width` _float_ - The width of the box.
-   `height` _float_ - The height of the box.
-   `rotation` _float_ - The rotation of the 3D box.
-   `thickness` _float_ - The thickness of the box [0.0...1.0]
-   `perspective` _float_ - The distortion of the 3D effect [0.0...1.0]
-   `shift` _float_ - The vertical shift of the 3D effect [-1.0...1.0]
-   `pinch` _float_ - The pinch of the 3D effect [-1.0...1.0]
-   `shade` _float_ - The strength of the shading [0.0...1.0]
-   `light` _float_ - The angle of the light source, `0` = front [0...360]
-   `shadow_dist` _float_ - The distance of the shadow from the box bottom, [0.0...1.0]
-   `shadow_size` _float_ - The size of the shadow
-   `zorder` _integer_ - The zorder of the lowest image
-   `art_front` _feImage_ - The object for the front face
-   `art_right` _feImage_ - The object for the right face
-   `art_back` _feImage_ - The object for the back face
-   `art_left` _feImage_ - The object for the left face
-   `art_top` _feImage_ - The object for the top face
-   `art_bottom` _feImage_ - The object for the bottom face
-   `art_shadow` _feImage_ - The object for the shadow

## Functions

-   `set_pos(x, y, width, height)` - Set the location and position.

## Notes

**_It's not a real 3D box!_**

It's a collection of image objects skewed and pinched and poked and prodded to appear 3D. The illusion will break when the arguments are pushed too far, but for most purposes it works quite well.

-   Requires `Attract-Mode Plus v3.2.0` or later
-   Requires the [`perspective`](https://github.com/Chadnaut/Attract-Mode-Modules/tree/master/modules/perspective) module
