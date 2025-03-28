# Attract Mode Modules

> Attract-Mode Modules, Plugins, and Scripts  
> Chadnaut 2025  
> https://github.com/Chadnaut/Attract-Mode-Modules  
>\
>[<img src="https://github.com/Chadnaut/Attract-Mode-Plus-Squirrel/blob/master/assets/images/banner.png?raw=true" width="48" align="left">][extension]
Get the [*AM+ Squirrel*][extension] extension for VS Code
<br><sup><sub>A suite of support tools to enhance your AM+ development experience. Code completions, highlighting, linting, formatting, and more!</sub></sup>

[extension]: https://marketplace.visualstudio.com/items?itemName=chadnaut.am-squirrel

## Quickstart

- Download the repository using the green button `Code` > `Download ZIP`.
- Extract the desired `module` / `plugin` / `layout` into the corresponding AM folder.
- Configure your AM display to use the provided example layout.

## Modules

- *Debug* - Testing or debugging during development.
- *Element* - A new layout element with unique behaviors.
- *Shader* - Adds an effect to an existing layout element.
- *Utility* - Additional functions and classes.

[Blur]: ./modules/blur/README.md
[Chart]: ./modules/chart/README.md
[Console]: ./modules/console/README.md
[Ease]: ./modules/ease/README.md
[FileSystem]: ./modules/fs/README.md
[Frame]: ./modules/frame/README.md
[LogPlus]: ./modules/logplus/README.md
[Mask]: ./modules/mask/README.md
[MessageQueue]: ./plugins/MessageQueue/README.md
[Perspective]: ./modules/perspective/README.md
[Quicksort]: ./modules/quicksort/README.md
[Regex]: ./modules/regex/README.md
[Retention]: ./modules/retention/README.md
[Sequence]: ./modules/sequence/README.md
[Stringify]: ./modules/stringify/README.md
[Timer]: ./modules/timer/README.md
[UnitTest]: ./modules/unittest/README.md

|Preview|Version|Description|Type|Demo|
|-|-|-|-|-|
|[<img width="64" height="42" src="./modules/blur/example.png"/>][Blur]|`v0.1.0`|[Blur] - Gaussian blur|*Shader*|[Example](./layouts/Example.Blur/)|
|[<img width="64" height="42" src="./modules/chart/example.png"/>][Chart]|`v1.2.0`|[Chart] - Plot events over time|*Element*|[Example](./layouts/Example.Chart/)|
|[<img width="64" height="42" src="./modules/console/example.png"/>][Console]|`v0.9.1`|[Console] - Coloured message list with animated typing|*Element*|[Example](./layouts/Example.Console/)|
|[<img width="64" height="42" src="./modules/ease/example.png"/>][Ease]|`v0.9.0`|[Ease] - Easing methods|*Utility*|[Example](./layouts/Example.Ease/)|
|[<img width="64" height="42" src="./modules/frame/example.png"/>][Frame]|`v0.1.1`|[Frame] - 9-slice image scaling|*Shader*|[Example](./layouts/Example.Frame/)|
|[<img width="64" height="42" src="./modules/fs/example.png"/>][FileSystem]|`v0.9.0`|[FileSystem] - File reading and writing|*Utility*|[Example](./layouts/Example.FileSystem/)|
|[<img width="64" height="42" src="./modules/logplus/example.png"/>][LogPlus]|`v0.6.4`|[LogPlus] - Extended logging functionality|*Debug*|[Example](./layouts/Example.LogPlus/)|
|[<img width="64" height="42" src="./modules/mask/example.png"/>][Mask]|`v0.3.1`|[Mask] - 9-slice image masking|*Shader*|[Example](./layouts/Example.Mask/)|
|[<img width="64" height="42" src="./plugins/MessageQueue/example.png"/>][UnitTest]|`v0.1.1`|[MessageQueue] - Send messages using files|*Utility*|[Example](./plugins/MessageQueue/README.md#quickstart)|
|[<img width="64" height="42" src="./modules/perspective/example.png"/>][Perspective]|`v0.5.4`|[Perspective] - Perspective correct texture mapping|*Shader*|[Example](./layouts/Example.Perspective/)|
|[<img width="64" height="42" src="./modules/quicksort/example.png"/>][Quicksort]|`v0.1.1`|[Quicksort] - Yielding Quicksort|*Utility*|[Example](./layouts/Example.Quicksort/)|
|[<img width="64" height="42" src="./modules/regex/example.png"/>][Regex]|`v0.2.1`|[Regex] - Regular Expression handler|*Utility*|[Example](./layouts/Example.Regex/)|
|[<img width="64" height="42" src="./modules/retention/example.png"/>][Retention]|`v0.7.2`|[Retention] - Surface image persistence|*Shader*|[Example](./layouts/Example.Retention/)|
|[<img width="64" height="42" src="./modules/sequence/example.png"/>][UnitTest]|`T.B.A.`|[Sequence] - Stackable animation system|*Utility*||
|[<img width="64" height="42" src="./modules/stringify/example.png"/>][Stringify]|`v0.1.8`|[Stringify] - JSON-like value stringification|*Utility*|[Example](./layouts/Example.Stringify/)|
|[<img width="64" height="42" src="./modules/timer/example.png"/>][Timer]|`v0.3.0`|[Timer] - Call a function at a later time|*Utility*|[Example](./layouts/Example.Timer/)|
|[<img width="64" height="42" src="./modules/unittest/example.png"/>][UnitTest]|`v1.1.2`|[UnitTest] - Testing and benchmarking|*Debug*|[Test](./layouts/Example.UnitTest/)<br>[Bench](./layouts/Example.Benchmark/)|

*NOTE: Shader-based effects such as Blur, Frame, and Mask will not work simultaneously upon a single element. This can be achieved by nesting elements within Surfaces and applying one effect to each element.*

## Looking for More?

For experiments that haven't made it to the Module stage check out:

- https://github.com/Chadnaut/Attract-Mode-Experiments
