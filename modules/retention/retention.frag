#version 120

uniform sampler2D texture;
uniform sampler2D texture2;
uniform float persistance = 0.0;
uniform float falloff = 0.0;

void main() {
    gl_FragColor = gl_Color * max(
        texture2D(texture, gl_TexCoord[0].xy),
        max(texture2D(texture2, gl_TexCoord[0].xy) * persistance - vec4(falloff), vec4(0))
    );
}