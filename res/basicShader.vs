#version 330

in vec3 position;
in vec2 texCoord;
in vec3 normal;

uniform mat4 transform;

out vec2 texCoord0;
out vec3 normal0;

void main()
{
    gl_Position = transform * vec4(position, 1.0);
    texCoord0 = texCoord;
    normal0 = (transform * vec4(normal, 0.0)).xyz;
}
