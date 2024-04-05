# Chart

> Plot events over time  
> Version 1.2.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("chart");
::chart <- Chart();

function my_method() {
    ::chart.add("My Chart", 100);
}

// Example calls method a random number of times per frame
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    for (local i=0, n=(100.0 * rand() / RAND_MAX); i < n; i++) my_method();
}
```

The first time `add()` is called the timeline is created; each subsequent call increments its value, which is reset every frame.

![Example](example.png)\
*Example chart showing frame spikes and various method calls*

## Properties

- `x` *int* - Get/set x position of chart.
- `y` *int* - Get/set y position of chart.
- `width` *int* - Get/set<sup>1</sup> width of chart.
- `height` *int* - Get/set height of each timeline.
- `thickness` *int* - Get/set<sup>1</sup> thickness of timeline bars.
- `alpha` *int* - Get/set timeline bar alpha.
- `font` *string* - Get/set timeline label font.
- `char_size` *int* - Get/set timeline label size.
- `outline` *int* - Get/set timeline label outline.
- `align` *Align* - Get/set timeline label alignment.
- `margin` *int* - Get/set timeline label margin.
- `scroll` *bool* - Get/set timeline animation.
- `pace` *bool* - Get/set if timeline should maintain a stable pace.
- `grid` *int* - Get/set millisecond interval of timeline grid.
- `theme` *object* - Get/set theme colour object
  - `{ background, grid, head, lag, text, chart[] }` where each is `[r,g,b]`
  - See code for example
- `zorder` *int* - Get/set zorder of chart.
- `visible` *bool* - Get/set visibility of chart.

Note<sup>1</sup> - Cannot be changed once timelines added.

## Functions

- `add(title, max?, step?, callback?)` - Add a timeline to the chart.
    - `title` *string* - Label for the timeline.
    - `max` *int* - (Optional, default = 100) Maximum value, adjust to suit your results.
    - `step` *int* - (Optional, default = 1) Increment value.
    - `callback` *function* - (Optional, default = null) Value formatter.
        - `function (value, frame_time) { return value; }`
        - `@(v, t) v` Same as above but written as a lambda.
- `clear()` - Clear the chart.

## About Pace

If your layout performs too many operations in a single tick it may *lag*, which results in a lower framerate. The timeline head will turn from **white** to **red** to indicate this.

By default `pace` is set to `true`, which maintains the timeline speed even if the framerate drops - everything gets `stretched` out a bit so grid lines keep the same relative spacing.

When `pace` is set to `false`, the chart will lag along with the framerate, which results in grid lines being drawn too close together during periods of lag.
