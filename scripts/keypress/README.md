# Keypress

> Send keypress to a window  
> Version 0.2.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [Python 3.12.1](https://www.python.org/downloads/)

```sh
python -m pip install --upgrade pip
python -m pip install --upgrade pywin32
```

## Usage

```sh
python keypress.py key window_name? class_name?
```

- `key` - Key to press & release.
  - `9` - keycode 9 (which is VK_TAB).
  - `Q` - char, uses `ord` to find keycode.
  - `"'9'"` - double-quoted char, uses `ord` to find keycode.
  - `F5` - string gets prefixed with VK_ to create win32con constant.
  - `VK_F5` - matching constant from [win32con](https://github.com/SublimeText/Pywin32/blob/master/lib/x32/win32/lib/win32con.py).
- `window_name` - (Optional) Title of the target window.
- `class_name` - (Optional) Class of the target window.

Note - sends a keypress to *all* matching windows, or foreground window if none provided.

## Example

During development it is useful to automatically reload the layout after you've made a change. In this example the `ReloadHotkey` plugin is setup to reload when `F5` is pressed.

```sh
# First send ESCAPE to exit any open menus
python ./scripts/keypress/keypress.py VK_ESCAPE Attract-Mode SFML_Window

# Then send F5 to trigger a layout reload
python ./scripts/keypress/keypress.py VK_F5 Attract-Mode SFML_Window
```

When using [VSCode](https://code.visualstudio.com/download) the extension [RunOnSave](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave) can be used to call these actions. Add the `"emeraldwalk.runonsave"` section to your `.code-workspace` file.

```json
"settings": {
  "emeraldwalk.runonsave": {
    "commands": [
      {
        "match": ".*",
        "cmd": "python ./scripts/keypress/keypress.py VK_ESCAPE Attract-Mode SFML_Window && python ./scripts/keypress/keypress.py VK_F5 Attract-Mode SFML_Window"
      }
    ]
  }
}
```
*Edit the path to point to the script relative to your .code-workspace file.*
