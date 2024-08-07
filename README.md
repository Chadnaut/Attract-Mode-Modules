# Attract Mode Modules

> Attract-Mode Modules, Plugins, and Scripts  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

- Download the repository using the green button `Code` > `Download ZIP`.
- Extract the desired `module` / `plugin` / `layout` into the corresponding AM folder.
- Configure your AM display to use the provided example layout.

## For Designers

Extra features designers can use to build layouts.

### Modules

|Screenshot|Version|Module|Example|
|:-|:-|:-|:-|
|[<img src="./modules/blur/example.png" width="120"/>](./modules/blur/README.md)|v0.1.0|[Blur](./modules/blur/README.md) - Gaussian blur|[Example](./layouts/Example.Blur/)|
|[<img src="./modules/ease/example.png" width="120"/>](./modules/ease/README.md)|v0.9.0|[Ease](./modules/ease/README.md) - Easing methods|[Example](./layouts/Example.Ease/)|
|[<img src="./modules/console/example.png" width="120"/>](./modules/console/README.md)|v0.9.1|[Console](./modules/console/README.md) - Coloured message list with animated typing|[Example](./layouts/Example.Console/)|
|[<img src="./modules/frame/example.png" width="120"/>](./modules/frame/README.md)|v0.1.1|[Frame](./modules/frame/README.md) - 9-slice image scaling|[Example](./layouts/Example.Frame/)|
|[<img src="./modules/mask/example.png" width="120"/>](./modules/mask/README.md)|v0.3.1|[Mask](./modules/mask/README.md) - 9-slice image masking|[Example](./layouts/Example.Mask/)|
|[<img src="./modules/perspective/example.png" width="120"/>](./modules/perspective/README.md)|v0.5.4|[Perspective](./modules/perspective/README.md) - Perspective correct texture mapping|[Example](./layouts/Example.Perspective/)|
|[<img src="./modules/retention/example.png" width="120"/>](./modules/retention/README.md)|v0.7.2|[Retention](./modules/retention/README.md) - Surface image persistence|[Example](./layouts/Example.Retention/)|
|Coming Soon|-|[Sequence](./modules/sequence/README.md) - Stackable animation system|Coming Soon|

*NOTE: Shader-based effects such as Blur, Frame, and Mask will not work simultaneously upon a single entity. This can be averted by placing the entity within a Surface, and applying one effect to the entity, and the other to the Surface.*

## For Developers

Tools and utilities to improve workflow and debugging.

### Modules

|Screenshot|Version|Module|Example|
|:-|:-|:-|:-|
|[<img src="./modules/chart/example.png" width="120"/>](./modules/chart/README.md)|v1.2.0|[Chart](./modules/chart/README.md) - Plot events over time|[Example](./layouts/Example.Chart/)|
|[<img src="./modules/fs/example.png" width="120"/>](./modules/fs/README.md)|v0.9.0|[FileSystem](./modules/fs/README.md) - File reading and writing|[Example](./layouts/Example.FileSystem/)|
|[<img src="./modules/logplus/example.png" width="120"/>](./modules/logplus/README.md)|v0.6.4|[LogPlus](./modules/logplus/README.md) - Extended logging functionality|[Example](./layouts/Example.LogPlus/)|
|[<img src="./modules/quicksort/example.png" width="120"/>](./modules/quicksort/README.md)|v0.1.1|[Quicksort](./modules/quicksort/README.md) - Yielding Quicksort|[Example](./layouts/Example.Quicksort/)|
|[<img src="./modules/regex/example.png" width="120"/>](./modules/regex/README.md)|v0.2.1|[Regex](./modules/regex/README.md) - Regular Expression handler|[Example](./layouts/Example.Regex/)|
|[<img src="./modules/stringify/example.png" width="120"/>](./modules/stringify/README.md)|v0.1.8|[Stringify](./modules/stringify/README.md) - JSON-like value stringification|[Example](./layouts/Example.Stringify/)|
|[<img src="./modules/timer/example.png" width="120"/>](./modules/timer/README.md)|v0.2.0|[Timer](./modules/timer/README.md) - Call a function at a later time|[Example](./layouts/Example.Timer/)|
|[<img src="./modules/unittest/example.png" width="120"/>](./modules/unittest/README.md)|v1.1.2|[UnitTest](./modules/unittest/README.md) - Testing and benchmarking|[Testing](./layouts/Example.UnitTest/)<br>[Benchmarking](./layouts/Example.Benchmark/)|

### Plugins

|Type|Version|Module|Example|
|:-|:-|:-|:-|
|Plugin|v0.1.1|[Message Queue](./plugins/MessageQueue/README.md) - Send messages using files|[Example](./plugins/MessageQueue/README.md#quickstart)|
|Plugin|v0.1.0|[Reload Hotkey](./plugins/ReloadHotkey/README.md) - Reload layout when custom key pressed|[Example](./plugins/ReloadHotkey/README.md#quickstart)|

### Scripts

|Type|Version|Module|Example|
|:-|:-|:-|:-|
|Python|v0.2.0|[Keypress](./scripts/keypress/README.md) - Send keypress to a window|[Example](./scripts/keypress/README.md#example)|
|Python|v0.3.0|[Link](./scripts/link/README.md) - Create a series of symlinks|[Example](./scripts/link/README.md#example)|
|Python|v0.1.2|[Version](./scripts/version/README.md) - Sync version info between files|[Example](./scripts/version/README.md#example)|

## Looking for More?

Sometimes short demos are created to illustrate a concept - for experiments that haven't made it to the module stage checkout:

https://github.com/Chadnaut/Attract-Mode-Experiments
