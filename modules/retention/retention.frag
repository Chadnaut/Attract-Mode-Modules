#version 120

uniform sampler2D texture;
uniform sampler2D texture2;
uniform float persistance = 0.0;

void main() {
    gl_FragColor = max(
        gl_Color * texture2D(texture, gl_TexCoord[0].xy),
        texture2D(texture2, gl_TexCoord[0].xy) * persistance
    );
}