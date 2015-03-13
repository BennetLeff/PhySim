#version 430

in vec3 position;
in vec2 texCoord;
in vec3 normal;

layout(location = 1) uniform mat4 transform;
layout(location = 2) uniform mat4 camera;

out vec2 texCoord0;
out vec3 normal0;

out vec3 position0;
out mat4 model; // the transform variable

void main()
{
    gl_Position = camera * transform * vec4(position, 1.0);
    texCoord0 = texCoord;
    normal0 = (transform * vec4(normal, 0.0)).xyz;
    position0 = position;
    model = transform;
}
