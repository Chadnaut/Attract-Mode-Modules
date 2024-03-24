# Mask

> 9-slice image masking  
> Version 0.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("mask");

local mask = fe.add_image("mask.png");
mask.visible = false;

local art = Mask(fe.add_image("mask.png", 50, 50, 400, 300));
art.mask = mask;
art.set_mask_slice(50, 50, 50, 50);
```

![Example](example.png)\
*A 9-slice mask, text with a gradient mask, and a gradient with a text mask*

## Properties

- `mask` *fe.Image* - Source texture for the mask.
- `mask_type` *enum* - Type of mask to use.
  - `MaskType.None` - No mask.
  - `MaskType.Multiply` - (Default) Multiplies image using mask colour and alpha.
  - `MaskType.Grayscale` - Use the lightness of the mask to multiply alpha only.
- `mask_mirror_x` *bool* - Flip the mask horizontally.
- `mask_mirror_y` *bool* - Flip the mask vertically.
- `mask_slice_left` *int* - Width of mask left 9-slice column.
- `mask_slice_right` *int* - Width of mask right 9-slice column.
- `mask_slice_top` *int* - Height of mask top 9-slice row.
- `mask_slice_bottom` *int* - Height of mask bottom 9-slice row.

See the `frame` module in this repo for more information about 9-slice.

## Functions

- `set_mask_slice(l, t, r, b)` - Set all mask slice sizes at once.

## Notes

- When using with a `surface` the `mask_mirror_y = 1` must be set due to how surfaces work internally.
- The mask breaks when `width < mask_slice_left + mask_slice_right + 2` or `height < mask_slice_top + mask_slice_bottom + 2`, ie: don't make the object smaller than the slices.
