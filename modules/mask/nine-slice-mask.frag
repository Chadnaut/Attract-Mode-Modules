#version 120

uniform sampler2D texture;
uniform sampler2D mask;
uniform vec2 texture_size = vec2(0, 0);
uniform float width = 0.0;
uniform float height = 0.0;
uniform float mask_type = 0.0;
uniform float mask_mirror_x = 0.0;
uniform float mask_mirror_y = 0.0;
uniform float mask_slice_left = 0.0;
uniform float mask_slice_top = 0.0;
uniform float mask_slice_right = 0.0;
uniform float mask_slice_bottom = 0.0;

vec2 object_size = vec2(width, height);
vec4 slice = vec4(mask_slice_left, mask_slice_top, mask_slice_right, mask_slice_bottom);
vec2 mirror = vec2(mask_mirror_x, mask_mirror_y);

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    gl_FragColor = gl_Color * texture2D(texture, uv);
    if (bool(mask_type)) {
        vec2 uv2 = vec2(bool(mirror.x) ? 1.0 - uv.x : uv.x, bool(mirror.y) ? 1.0 - uv.y : uv.y);
        vec2 s = object_size / texture_size;
        vec4 b = (slice + 1.0) / texture_size.xyxy;
        vec2 t = clamp((s * uv2 - b.xy) / (s - b.xy - b.zw), 0.0, 1.0);
        vec2 uv9 = mix(uv2 * s, 1.0 - s * (1.0 - uv2), t);
        vec4 m = texture2D(mask, uv9);
        gl_FragColor *= (mask_type == 2) ? vec4(1, 1, 1, dot(m.rgb, vec3(0.412453, 0.357580, 0.180423))) : m;
    }
}