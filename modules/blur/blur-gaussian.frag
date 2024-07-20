#version 120

#define FACTOR  0.39894
#define SPREAD  6.0
#define HALF_PI 1.57080

uniform sampler2D texture;
uniform sampler2D blur_mask;
uniform float width = 0.0;
uniform float height = 0.0;
uniform float blur_size = 0.0;
uniform float blur_rotation = -HALF_PI;
uniform float blur_channel = 0.0;
uniform float is_surface = 0.0;

// Average multiple texture lookups weighted towards the uv
vec4 directional_gaussian(vec2 uv, float size, float angle) {
    if (size == 0) {
        return texture2D(texture, uv);
    }

    int n = int(size / 2);
    float sigma = size / SPREAD;
    float sigma2 = sigma * sigma;
    float fs = FACTOR / sigma;
    float z = fs;
    vec4 col = z * texture2D(texture, uv);
    vec2 px = vec2(cos(angle), -sin(angle)) / vec2(width, height);

    for (int i = 1; i <= n; i++) {
        float f = float(i);
        float k = fs * exp(-0.5 * f * f / sigma2);
        z += k + k;
        col += k * (texture2D(texture, uv - f * px) + texture2D(texture, uv + f * px));
    }

    return col / z;
}

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    bool is_surf = bool(is_surface);
    vec4 m = texture2D(blur_mask, is_surf ? vec2(uv.x, 1.0 - uv.y) : uv);
    float s = m.r * blur_size;
    float a = blur_rotation + (bool(blur_channel) ? atan(m.g * 2.0 - 1.0, -m.b * 2.0 + 1.0) : 0);

    gl_FragColor = gl_Color * directional_gaussian(uv, s, is_surf ? -a : a);
}