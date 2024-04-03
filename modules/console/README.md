# Console

> Coloured message list with animated typing  
> Version 0.8.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [stringify](https://github.com/Chadnaut/Attract-Mode-Modules/blob/master/modules/stringify) - module can be found in this repo

## Quickstart

```cpp
fe.load_module("console");
::console <- Console();

// the following lines animate printing, remove to print instantly
::console.char_delay = 10;
::console.line_delay = 100; 
::console.line_wait = true;

::console.print("Success", [0, 255, 0]); // with text colour
::console.print("Info");
::console.print({ a = 1, b = 2.0 }); // print objects
::console.print();
::console.print("Failure", null, [200, 0, 0, 255]); // with bg colour
```

![Example](example.png)\
*Example console output*

## Properties

- `x` *int* - Get/set x position of console.
- `y` *int* - Get/set y position of console.
- `width` *int* - Get/set<sup>1</sup> width of console.
- `height` *int* - Get/set<sup>1</sup> height of console.
- `font` *string* - Get/set<sup>1</sup> console font.
- `char_size` *int* - Get/set<sup>1</sup> console font size.
- `line_space` *int* - Get/set<sup>1</sup> console font line space.
- `lines` *int* - Get total number of printed lines.
- `lines_total` *int* - Get total number of lines that fit in the console.
- `text_red` *int* - Get/set red colour level of console text.
- `text_green` *int* - Get/set green component of console text.
- `text_blue` *int* - Get/set blue component of console text.
- `bg_red` *int* - Get/set bg_red component of console background.
- `bg_green` *int* - Get/set bg_green component of console background.
- `bg_blue` *int* - Get/set bg_blue component of console background.
- `alpha` *int* - Get/set alpha of console.
- `zorder` *int* - Get/set zorder of console.
- `visible` *bool* - Get/set visibility of console.
- `char_delay` *int* - Get/set milliseconds between printing message characters.
- `line_delay` *int* - Get/set milliseconds between printing lines.
- `line_wait` *bool* - Get/set wait for the previous line to finish before starting next.
- `ready` *bool* - Returns `true` if all messages finished printing.

Note<sup>1</sup> - Cannot be changed once messages are printed.

## Functions

- `print(message, text_rgb?, bg_rgb?)` - Add message to the console, rgb = [r,g,b].
- `clear()` - Clear all messages.
- `flush()` - Output all pending (delayed) messages.
- `get_message(index)` - Return message for line.
- `set_message(index, message)` - Set message for line.
- `get_text_rgb(index?)` - Get text_rgb for line, or default.
- `set_text_rgb(index?, r, g, b)` - Set text_rgb for line, or default.
- `get_bg_rgb(index?)` - Set bg_rgb for line, or default.
- `set_bg_rgb(index?, r, g, b)` - Get bg_rgb for line, or default.
