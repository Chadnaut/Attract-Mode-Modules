# Timer

> Call a function at a later time  
> Version 0.3.0 2025-03-27  
> Chadnaut  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
fe.load_module("timer")

local t = 0
set_interval(@() fe.log(format("Interval %d", t++)), 1000)

/*
Interval 0
Interval 1
Interval 2
...
*/
```
*Calling a function repeatedly*

```cpp
fe.load_module("timer")

local start = fe.layout.time
set_timeout(@() fe.log(format("Timeout %d", fe.layout.time - start)), 1000)

/*
Timeout 1000
*/
```

*Calling a function after a delay*

## Functions

- `set_timeout(callback, delay?)` - Fire callback once after delay, returns id
- `set_interval(callback, delay?)` - Repeatedly fire callback after delay, returns id
- `clear_timeout(id)` - Remove timeout by id
- `clear_interval(id)` - Remove interval by id

## Notes

- If `delay == 0` the callback will be fired on the next frame.
- If `delay < frametime` the callback will be fired multiple times.
- The exact timing of the callback is dependant on `frametime`.
- For example, on a `60fps` system the timer with fire within a `1000/60` = `16ms` window.