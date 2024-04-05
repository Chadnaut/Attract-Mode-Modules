# Link

> Create a series of symlinks  
> Version 0.3.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

[Python 3.12.1](https://www.python.org/downloads/)

```sh
python -m pip install --upgrade pyuac
```

## Usage

```sh
python add_symlinks.py
```

On first run `config.ini` will be created - edit this file with your preferred links then run the script again.

Symbolic links are created for each listing in `config.ini`, removing the need to copy files from your development path to various AM locations.

## Example

```ini
[link]
root = ../../
src =
  modules/chart
  modules/console
  modules/stringify
dest =
  C:/attract-mode
  C:/attract-mode-plus
  C:/attract-mode-plus-alpha
```

- `link` - A unique name for the section
  - `root` - Relative path from the script to your source root (may also be absolute path).
  - `src` - List of dirs/files within the root to create symlinks for.
  - `dest` - List of dirs to create symlinks in.

Note - in VSCode a `Run Python File` play button will appear in the top-right corner when the script is open - press it to run the script.

## Advanced

The `config.ini` may contain multiple sections:

```ini
# Link dev modules to attract-mode
[link_modules]
root = ../../
src =
  modules/chart
  modules/console
  modules/stringify
dest =
  C:/attract-mode

# Link attract-mode config to dev
[link_config]
root = C:/attract-mode
src =
  attract.am
  attract.cfg
  last_run.log
  script.nv
  window.am
dest =
  C:/dev/Attract-Mode-Modules
```

It's useful having AM config & logs accessible in your workspace for debugging.
