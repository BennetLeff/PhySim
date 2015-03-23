#version 150

in vec3 position;
in vec2 texCoord;
in vec3 normal;

uniform mat4 transform;
uniform mat4 camera;

out vec2 texCoord0;
out vec3 normal0;
out vec3 position0;

void main()
{
    texCoord0 = texCoord;
    normal0 = normal;
    position0 = position;

    gl_Position = camera * transform * vec4(position, 1.0);
}
