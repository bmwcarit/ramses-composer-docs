#version 300 es

precision mediump float;

uniform sampler2D u_ColorBuffer;
uniform sampler2D u_DepthBuffer;
in vec2 v_TextureCoordinate;

out vec4 fragColor;

void main()
{
    if(v_TextureCoordinate.x > 0.5)
    {
        fragColor = texture(u_ColorBuffer, v_TextureCoordinate);
    }
    else
    {
        vec4 depth = texture(u_DepthBuffer, v_TextureCoordinate);
        vec4 enhanceContrastDepth = 1.0 - (1.0 - depth) * 10.0;
        fragColor = enhanceContrastDepth;
    }
}
