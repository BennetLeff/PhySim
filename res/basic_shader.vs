#version 120

//layout(location = 0) in vec3 position;

attribute vec3 position;
attribute vec2 tex_coord;

uniform mat4 transform;

varying vec2 tex_coord0;

void main()
{
    gl_Position = transform * vec4(position, 1.0);
    tex_coord0 = tex_coord;
}
