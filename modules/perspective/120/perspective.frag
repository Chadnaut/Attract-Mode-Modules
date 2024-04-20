#version 120

uniform sampler2D texture;

void main() {
    gl_FragColor = gl_Color * texture2D(texture, gl_TexCoord[0].xy / gl_TexCoord[0].w);
}