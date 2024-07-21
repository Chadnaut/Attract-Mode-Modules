# Ease

> Easing methods  
> Version 0.9.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

```cpp
::fe.load_module("ease");

for (local i=0, n=10; i<=n; i++) {
    print(::ease.out_cubic(i.tofloat(), 0.0, 1.0, n.tofloat()) + "\n");
}
```

```log
0
0.271
0.488
0.657
0.784
0.875
0.936
0.973
0.992
0.999
1
```

![Example](example.png)\
*Example easings*

## Functions

### Penner

- `::ease.none(t, b, c, d)`
- `::ease.linear(t, b, c, d)`
- `::ease.in_quad(t, b, c, d)`
- `::ease.in_cubic(t, b, c, d)`
- `::ease.in_quart(t, b, c, d)`
- `::ease.in_quint(t, b, c, d)`
- `::ease.in_sine(t, b, c, d)`
- `::ease.in_expo(t, b, c, d)`
- `::ease.in_circ(t, b, c, d)`
- `::ease.in_elastic(t, b, c, d)`
- `::ease.in_back(t, b, c, d)`
- `::ease.in_bounce(t, b, c, d)`
- `::ease.out_quad(t, b, c, d)`
- `::ease.out_cubic(t, b, c, d)`
- `::ease.out_quart(t, b, c, d)`
- `::ease.out_quint(t, b, c, d)`
- `::ease.out_sine(t, b, c, d)`
- `::ease.out_expo(t, b, c, d)`
- `::ease.out_circ(t, b, c, d)`
- `::ease.out_elastic(t, b, c, d, a?, p?)`
- `::ease.out_back(t, b, c, d, s?)`
- `::ease.out_bounce(t, b, c, d)`
- `::ease.in_out_quad(t, b, c, d)`
- `::ease.in_out_cubic(t, b, c, d)`
- `::ease.in_out_quart(t, b, c, d)`
- `::ease.in_out_quint(t, b, c, d)`
- `::ease.in_out_sine(t, b, c, d)`
- `::ease.in_out_expo(t, b, c, d)`
- `::ease.in_out_circ(t, b, c, d)`
- `::ease.in_out_elastic(t, b, c, d, a?, p?)`
- `::ease.in_out_back(t, b, c, d, s?)`
- `::ease.in_out_bounce(t, b, c, d)`
- `::ease.out_in_quad(t, b, c, d)`
- `::ease.out_in_cubic(t, b, c, d)`
- `::ease.out_in_quart(t, b, c, d)`
- `::ease.out_in_quint(t, b, c, d)`
- `::ease.out_in_sine(t, b, c, d)`
- `::ease.out_in_expo(t, b, c, d)`
- `::ease.out_in_circ(t, b, c, d)`
- `::ease.out_in_elastic(t, b, c, d, a?, p?)`
- `::ease.out_in_back(t, b, c, d, s?)`
- `::ease.out_in_bounce(t, b, c, d)`

### Step

- `::ease.step_jump_start(t, b, c, d, n)`
- `::ease.step_jump_end(t, b, c, d, n)`
- `::ease.step_jump_none(t, b, c, d, n)`
- `::ease.step_jump_both(t, b, c, d, n)`
- `::ease.get_step_jump_start(steps)` - Returns easing function `function(t, d, c, d) {}`
- `::ease.get_step_jump_end(steps)` - Returns easing function `function(t, d, c, d) {}`
- `::ease.get_step_jump_both(steps)` - Returns easing function `function(t, d, c, d) {}`
- `::ease.get_step_jump_none(steps)` - Returns easing function `function(t, d, c, d) {}`

### Cubic Bezier

- `::ease.get_cubic_bezier(x1, y1, x2, y2)` - Returns an easing function `function(t, d, c, d) {}`
  - Visit [cubic-bezier](https://cubic-bezier.com/) for an interactive bezier creation tool.

## Arguments

All easings accept the following arguments:

- `t` *float* - Current time (0...duration)
- `b` *float* - Beginning value (from)
- `c` *float* - Change in value (to - from)
- `d` *float* - Duration

Some easings accept optional arguments:

- `a` *float* = Amplitude
- `p` *float* = Period
- `s` *float* = Overshoot
- `n` *int* = Number of steps

## Further Reading

- [Robert Penner's Easing Functions](http://robertpenner.com/easing/)
- [Easing functions](https://easings.net/)
- [MDN animation-timing-function](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-timing-function)
- [MDN easing-function](https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function#cubic_b%C3%A9zier_easing_function)
- [Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)
- [gre/bezier-easing](https://github.com/gre/bezier-easing/blob/master/src/index.js)