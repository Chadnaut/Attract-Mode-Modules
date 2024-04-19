#version 120
#extension GL_EXT_gpu_shader4 : require

// object size in pixels
uniform float width;
uniform float height;
uniform float rotation;

// vertex offsets in pixels
uniform float offset_tl_x;
uniform float offset_tl_y;
uniform float offset_bl_x;
uniform float offset_bl_y;
uniform float offset_tr_x;
uniform float offset_tr_y;
uniform float offset_br_x;
uniform float offset_br_y;

// =============================================

// int modulo since "%" is not always supported
int mod_int(int x, int y) {
    return int(mod(float(x), float(y)));
}

// projected texture adjustment values
float[4] barycentric(vec2 tl, vec2 bl, vec2 tr, vec2 br) {
    vec2 a = bl - tr;
    vec2 b = tl - br;
    float cp = a.x * b.y - a.y * b.x;

    if (cp != 0.0) {
        vec2 c = tr - br;
        float s = (a.x * c.y - a.y * c.x) / cp;
        if (s > 0.0 && s < 1.0) {
            float t = (b.x * c.y - b.y * c.x) / cp;
            if (t > 0.0 && t < 1.0) {
                return float[4](s, t, 1.0 - t, 1.0 - s);
            }
        }
    }
    return float[4](1.0, 1.0, 1.0, 1.0);
}

// =============================================

void main() {
    // helpers
    vec2 size = vec2(width, height);
    float rad = radians(rotation);
    mat2 rot = mat2(cos(rad), -sin(rad), sin(rad), cos(rad));

    // position offsets
    vec2 offset[4] = vec2[4](
        vec2(offset_tl_x, offset_tl_y),
        vec2(offset_bl_x, offset_bl_y),
        vec2(offset_tr_x, offset_tr_y),
        vec2(offset_br_x, offset_br_y)
    );

    // texture adjustments
    float q[4] = barycentric(
        vec2(0.0, 0.0) + offset[0] / size,
        vec2(0.0, 1.0) + offset[1] / size,
        vec2(1.0, 0.0) + offset[2] / size,
        vec2(1.0, 1.0) + offset[3] / size
    );

    // add offset to vertex, this reshapes the mesh which distorts the texture
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex + vec4(offset[mod_int(gl_VertexID, 4)] * rot, 0.0, 0.0));

    // adjust texCoord to fix texture - use 'w' in fragment shader to complete the effect
    gl_TexCoord[0] = vec4((gl_TextureMatrix[0] * gl_MultiTexCoord0).xy, 0.0, 1.0) / q[mod_int(gl_VertexID, 4)];

    // forward the vertex color
    gl_FrontColor = gl_Color;
}