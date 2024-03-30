#version 120

uniform sampler2D texture;
uniform sampler2D texture2;
uniform float persistence = 0.0;
uniform float falloff = 0.0;

void main() {
    vec4 col1 = texture2D(texture2, gl_TexCoord[0].xy);
    vec4 col2 = texture2D(texture, gl_TexCoord[0].xy);
    gl_FragColor = gl_Color * max(col1, col2 * persistence - falloff);
}