# Perspective

> Perspective correct texture mapping  
> Version 0.5.4  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("perspective");

local object = Perspective(fe.add_artwork("snap", 0, 0, 400 400));
object.pinch_x = 100;
object.pinch_y = 100;
```

Wrap your Image, Artwork or Surface with the `Perspective()` class and use the resulting instance in its place. The `pinch_x` and `pinch_y` properties will now produce perspective-correct texture mapping.

![Example](example.png)\
*Native pinch (left), Perspective pinch (right)*

## Properties

These properties are *optional* if you would like precise control over the vertices, otherwise just use `pinch_x` and `pinch_y` as normal.

- `offset_tl_x` *int* - Get/set the top-left x offset.
- `offset_tl_y` *int* - Get/set the top-left y offset.
- `offset_bl_x` *int* - Get/set the bottom-left x offset.
- `offset_bl_y` *int* - Get/set the bottom-left y offset.
- `offset_tr_x` *int* - Get/set the top-right x offset.
- `offset_tr_y` *int* - Get/set the top-right y offset.
- `offset_br_x` *int* - Get/set the bottom-right x offset.
- `offset_br_y` *int* - Get/set the bottom-right y offset.

## Functions

- `set_offset(tl_x, tl_y, tr_x, tr_y, bl_x, bl_y, br_x, br_y)` - Set all offsets at once.

## Notes

- Setting `offset_*` properties does not back-fill `pinch` or `skew`.
- Perspective fails when `pinch_x >= width/2.0` or `pinch_y >= height/2.0`, please consume responsibly.
- Uses `#version 120` with `#extension GL_EXT_gpu_shader4` on OSX.
- Uses `#version 130` which provides `gl_VertexID` on other operting systems, which requires `OpenGL 2.0`.
- Over-pinching no longer creates "bow-ties", since the mesh remains a 4-point object rather than a 256-sliced [triangle strip](https://github.com/oomek/attractplus/blob/master/src/sprite.cpp#L300).

## Further Reading

- [Arbitrary Quadrilaterals in OpenGL ES 2.0 for Android](https://github.com/bitlush/android-arbitrary-quadrilaterals-in-opengl-es-2-0/blob/master/ArbitraryQuadrilateralsActivity.java)
- [Bilinear Interpolated Texture Mapping](https://pumpkin-games.net/wp/?p=215)
- [Quadrilateral Interpolation, Part 1](https://www.reedbeta.com/blog/quadrilateral-interpolation-part-1/)
- [WebGL 3D Perspective Correct Texture Mapping](https://webglfundamentals.org/webgl/lessons/webgl-3d-perspective-correct-texturemapping.html)
- [Texture mapping](https://en.wikipedia.org/wiki/Texture_mapping#Affine_texture_mapping)
- [Barycentric coordinate system](https://en.wikipedia.org/wiki/Barycentric_coordinate_system)
