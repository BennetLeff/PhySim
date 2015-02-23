#version 120

uniform float[] color;

uniform sampler2D diffuse;

varying vec2 tex_coord0;

void main()
{
    //gl_FragColor = vec4(color[0], color[1], color[2], 1.0);
    gl_FragColor = texture2D(diffuse, tex_coord0);
}
