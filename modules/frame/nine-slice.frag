#version 120

uniform sampler2D texture;
uniform vec2 texture_size = vec2(0, 0);
uniform float width = 0.0;
uniform float height = 0.0;
uniform float slice_left = 0.0;
uniform float slice_top = 0.0;
uniform float slice_right = 0.0;
uniform float slice_bottom = 0.0;

vec2 object_size = vec2(width, height);
vec4 slice = vec4(slice_left, slice_top, slice_right, slice_bottom) + 1.0;

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec2 s = object_size / texture_size;
    vec4 b = slice / texture_size.xyxy;
    vec2 t = clamp((s * uv - b.xy) / (s - b.xy - b.zw), 0.0, 1.0);
    vec2 uv9 = mix(uv * s, 1.0 - s * (1.0 - uv), t);
    gl_FragColor = gl_Color * texture2D(texture, uv9);
}