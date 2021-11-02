#version 300 es
precision highp float;

in vec3 a_Position;
in vec3 a_Normal;

uniform mat4 uWorldViewProjectionMatrix;

void main()
{
  gl_Position = uWorldViewProjectionMatrix * vec4(a_Position, 1.0);
}