#version 120

uniform sampler2D texture;
uniform sampler2D blur_mask;
uniform float blur_size = 0.0;
uniform float is_surface = 0.0;

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    bool is_surf = bool(is_surface);
    vec4 m = texture2D(blur_mask, is_surf ? vec2(uv.x, 1.0 - uv.y) : uv);
    float lod = m.r * blur_size;

    gl_FragColor = gl_Color * texture2D(texture, uv, lod);
}