# Console

> Coloured message list  
> Version 0.5  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- `stringify` - Module found in the above repo.

## Quickstart

```cpp
fe.load_module("console");
::console <- Console();

::console.print("Success", [0, 255, 0]);
::console.print("Info");
::console.print({ a = 1, b = 2.0 });
::console.print();
::console.print("Failure", null, [200, 0, 0, 255]);
```

![Perspective Example](example.png)\
*Example console output*

## Properties

- `x` *int* - Get/set x position of console.
- `y` *int* - Get/set y position of console.
- `width` *int* - Get/set<sup>1</sup> width of console.
- `height` *int* - Get/set<sup>1</sup> height of console.
- `font` *string* - Get/set<sup>1</sup> console font.
- `char_size` *int* - Get/set<sup>1</sup> console font size.
- `line_space` *int* - Get/set<sup>1</sup> console font line space.
- `text_red` *int* - Get/set red colour level of console text.
- `text_green` *int* - Get/set green component of console text.
- `text_blue` *int* - Get/set blue component of console text.
- `text_alpha` *int* - Get/set alpha component of console text.
- `bg_red` *int* - Get/set bg_red component of console background.
- `bg_green` *int* - Get/set bg_green component of console background.
- `bg_blue` *int* - Get/set bg_blue component of console background.
- `bg_alpha` *int* - Get/set bg_alpha component of console background.
- `alpha` *int* - Get/set alpha of console.
- `zorder` *int* - Get/set zorder of console.
- `visible` *bool* - Get/set visibility of console.

Note<sup>1</sup> - Cannot be set once messages are printed.

## Functions

- `print(message, text_rgb?, bg_rgb?)` - Add message to the console, rgb = [r,g,b,a?].
- `clear()` - Clear all messages.
- `get_message(index)` - Return message for line.
- `set_message(index, message)` - Set message for line.
- `get_text_rgb(index)` - Get text_rgb for line.
- `set_text_rgb(index, r, g, b, a?)` - Set text_rgb for line.
- `get_bg_rgb(index)` - Set bg_rgb for line.
- `set_bg_rgb(index, r, g, b, a?)` - Get bg_rgb for line.
