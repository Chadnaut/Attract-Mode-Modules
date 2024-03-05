# Send Keypress

> Send a keypress to the target window  
> Version 0.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

[Python 3.12.1](https://www.python.org/downloads/) - (Lower versions *may* work)

```sh
python -m pip install --upgrade pip
python -m pip install --upgrade pywin32
```

## Usage
```sh
python send_keypress.py F5 Attract-Mode SFML_Window
# python send_keypress.py key window_name class_name(optional)
```

Sends a keypress to *all* matching windows.

## Key Values

- 7 = keycode
- Q = char, uses `ord` to find keycode
- "'7'" = quoted char, uses `ord` to find keycode
- F5 = string gets prefixed with VK_ to create win32con constant
- VK_F5 = full constant from [win32con](https://github.com/SublimeText/Pywin32/blob/master/lib/x32/win32/lib/win32con.py)

## Development

During development it is useful to automatically reload the layout whenever you save a file. In this example the `ReloadHotkey` plugin is setup to reload when `F5` is pressed.

```sh
# First send ESCAPE to exit open menus
python ./scripts/keypress/send_keypress.py VK_ESCAPE Attract-Mode SFML_Window

# Then send F5 to trigger a layout reload
python ./scripts/keypress/send_keypress.py VK_F5 Attract-Mode SFML_Window
```

When using [VSCode](https://code.visualstudio.com/download) the extension [RunOnSave](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave) can be used to call these actions. Add the `"emeraldwalk.runonsave"` section to your `.code-workspace` file.

```json
"settings": {
  "emeraldwalk.runonsave": {
    "commands": [
      {
        "match": ".*",
        "cmd": "python ./scripts/keypress/send_keypress.py VK_ESCAPE Attract-Mode SFML_Window && python ./scripts/keypress/send_keypress.py VK_F5 Attract-Mode SFML_Window"
      }
    ]
  }
}
```

*Edit the path to point to the script relative to your .code-workspace file.*