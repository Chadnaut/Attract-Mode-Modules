# Chart

> Plot events over time  
> Version 0.2  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
// Create a global chart instance
fe.load_module("chart");
::chart <- Chart();

// Add a timeline to your method
function my_method() {
    ::chart.add("My Chart", 100);
}

// Example of calling your method
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    for (local i=0, n=(100.0 * rand() / RAND_MAX); i < n; i++) my_method();
}
```

The first time `chart.add()` is called the timeline is created; each subsequent call (per-frame) increments its value.

![Chart Example](example.png)

*Example chart showing frame spikes and various method calls*

## Usage

```cpp
::chart <- Chart({
    toggle = "custom2",
    theme = Chart.themes.neon,
});
```

`options` *object* (optional)
- `x` *int* - x position of chart
- `y` *int* - y position of chart
- `width` *int* - width of chart
- `size` *int* - height of each timeline
- `alpha` *int* - alpha of chart
- `char_size` *int* - size of label font
- `margin` *int* - margin for label font
- `thickness` *int* - thickness of timeline bars
- `scroll` *bool* - animate timeline body
- `grid` *int* - millisecond interval for grid-lines
- `theme` *array* - colours for chart `[[r,g,b], ...]` (see code for theme examples)
- `toggle` *string* - signal to show/hide chart
- `zorder` *int* - zorder for chart

```cpp
::chart.add(title, max, step, callback)
```

- `title` *string* - Label for the timeline
- `max` *int* - Maximum value (default = 100), adjust to suit your results
- `step` *int* - Increment value (default = 1)
- `callback` *function* - Value formatter (default = null)
  - `function (value, frame_time) { return value; }`
  - `@(v, t) v` Same as above but written as a lambda

## Advanced

Use the chart to show frame times:

```cpp
fe.load_module("chart");
::chart <- Chart();

local f = 1000.0 / ScreenRefreshRate; // 16.6666ms

::chart
    .add("FrameOver", f, 0, @(v, t) t - f)
    .add("FrameUnder", f, 0, @(v, t) t);
```

- `max` is the frame budget
- `step` is zero (unused)
- `callback` returns the *frame_time* value

In development you'll likely only require "FrameOver", which indicates processing spikes and dropped frames.

Note that image loading nearly always goes over-budget (then under-budget in the next frame if possible). [Attract-Mode Plus](https://github.com/oomek/attractplus/actions) is actively developing *Async Loader* to remedy this.
