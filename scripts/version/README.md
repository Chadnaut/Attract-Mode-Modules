# Version

> Sync version info between files  
> Version 0.1.1  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Requirements

- [Python 3.12.1](https://www.python.org/downloads/)

## Usage

```sh
python version.py
```

- `-s` - show skipped files
- `-w` - write changes to files

No changes will be made unless the `-w` flag is provided.

## About

- Scans `modules`, `plugins` and `scripts` folders
- Reads version info from `README.md`
- Updates `module.nut`, `plugin.nut`, or `*.py` header to match
- Updates root `README.md` tables to match

## Format

```md
# Title
> Description
> Version 1.2.3  
> Author
> https://your/link/here
```