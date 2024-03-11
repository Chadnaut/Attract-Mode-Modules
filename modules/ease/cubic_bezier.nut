local NEWTON_ITERATIONS = 4;
local NEWTON_MIN_SLOPE = 0.001;
local SUBDIVISION_PRECISION = 0.0000001;
local SUBDIVISION_MAX_ITERATIONS = 10;

local K_SPLINE_TABLE_SIZE = 11;
local K_SPLINE_TABLE_LAST = K_SPLINE_TABLE_SIZE - 1;
local K_SAMPLE_STEP_SIZE = 1.0 / (K_SPLINE_TABLE_SIZE - 1.0);

local get_bezier = function(t, a, b) {
    return (((1.0 - 3.0*b + 3.0*a)*t + (3.0*b - 6.0*a))*t + 3.0*a)*t;
}

local get_slope = function(t, a, b) {
    return 3.0*(1.0 - 3.0*b + 3.0*a)*t*t + 2.0*(3.0*b - 6.0*a)*t + (3.0*a);
}

local binary_subdivide = function(x, a, b, x1, x2) {
    local n, t, i = 0;
    do {
        t = a + (b - a) / 2.0;
        n = get_bezier(t, x1, x2) - x;
        if (n > 0.0) { b = t; } else { a = t; }
    } while ((fabs(n) > SUBDIVISION_PRECISION) && (++i < SUBDIVISION_MAX_ITERATIONS));
    return t;
}

local newton_raphson_iterate = function(x, t, x1, x2) {
    local n;
    for (local i = 0; i < NEWTON_ITERATIONS; i++) {
        n = get_slope(t, x1, x2);
        if (n == 0.0) return t;
        t -= (get_bezier(t, x1, x2) - x) / n;
    }
    return t;
}

// Returns an easing function
::ease.cubicBezier <- function(x1, y1, x2, y2) {
    if (!(0 <= x1 && x1 <= 1 && 0 <= x2 && x2 <= 1)) {
        throw "Cubic Bezier x values must be in [0, 1] range";
    }

    if (x1 == y1 && x2 == y2) {
        return ::ease.linear;
    }

    local sample_values = [];
    for (local i = 0; i < K_SPLINE_TABLE_SIZE; i++) {
        sample_values.push(get_bezier(i * K_SAMPLE_STEP_SIZE, x1, x2));
    }

    local get_t_for_x = function(x) {
        local interval_start = 0.0;
        local current_sample = 1;

        for (; current_sample != K_SPLINE_TABLE_LAST && sample_values[current_sample] <= x; current_sample++) {
            interval_start += K_SAMPLE_STEP_SIZE;
        }
        current_sample--;

        // Interpolate to provide an initial guess for t
        local dist = (x - sample_values[current_sample]) / (sample_values[current_sample + 1] - sample_values[current_sample]);
        local t_guess = interval_start + dist * K_SAMPLE_STEP_SIZE;
        local slope = get_slope(t_guess, x1, x2);

        if (slope >= NEWTON_MIN_SLOPE) {
            return newton_raphson_iterate(x, t_guess, x1, x2);
        } else if (slope == 0.0) {
            return t_guess;
        } else {
            return binary_subdivide(x, interval_start, interval_start + K_SAMPLE_STEP_SIZE, x1, x2);
        }
    }

    return function(t, b, c, d) {
        return c * get_bezier(get_t_for_x(t/d), y1, y2) + b;
    }
}