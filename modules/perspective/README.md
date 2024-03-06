# Perspective

> Perspective correct texture mapping  
> Version 0.1  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("perspective");

local object = fe.add_artwork("snap", 0, 0, 400 400);
object = Perspective(object);
object.pinch_x = 100;
object.pinch_y = 100;
```

Wrap your Image, Artwork or Surface with the `Perspective()` class and use the resulting instance in its place. The `pinch` and `skew` properties are applied using **shaders**, and all other properties fall through to the original object.

![Perspective Example](example.png)

*Native pinch (left), Perspective pinch (right)*

## Advanced

Vertex offsets may be set individually rather than using the pinch and skew shortcuts.

- `offset_tl_x` Top Left X offset
- `offset_tl_y` Top Left Y offset
- `offset_bl_x` Bottom Left X offset
- `offset_bl_y` Bottom Left Y offset
- `offset_tr_x` Top Right X offset
- `offset_tr_y` Top Right Y offset
- `offset_br_x` Bottom Right X offset
- `offset_br_y` Bottom Right Y offset

## Notes

- Perspective fails when `pinch_x >= width/2.0` or `pinch_y >= height/2.0`, please consume responsibly.
- Requires shader `#version 130` to provide `gl_VertexID` which is used to find the correct vertex to offset.
- Over-pinching no longer creates "bow-ties", since the mesh remains a 4-point object rather than a 256-sliced [triangle strip](https://github.com/oomek/attractplus/blob/master/src/sprite.cpp#L300).

## Further Reading

- [Arbitrary Quadrilaterals in OpenGL ES 2.0 for Android](https://github.com/bitlush/android-arbitrary-quadrilaterals-in-opengl-es-2-0/blob/master/ArbitraryQuadrilateralsActivity.java)
- [Bilinear Interpolated Texture Mapping](https://pumpkin-games.net/wp/?p=215)
- [Quadrilateral Interpolation, Part 1](https://www.reedbeta.com/blog/quadrilateral-interpolation-part-1/)
- [WebGL 3D Perspective Correct Texture Mapping](https://webglfundamentals.org/webgl/lessons/webgl-3d-perspective-correct-texturemapping.html)
- [Texture mapping](https://en.wikipedia.org/wiki/Texture_mapping#Affine_texture_mapping)
- [Barycentric coordinate system](https://en.wikipedia.org/wiki/Barycentric_coordinate_system)
