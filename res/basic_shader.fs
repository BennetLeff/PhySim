#version 120

uniform float[] color;

uniform sampler2D diffuse;

varying vec2 tex_coord0;

void main()
{
	if (true)
	{
		gl_FragColor = texture2D(diffuse, tex_coord0);
	}
	else
	{
		gl_FragColor = vec4(0.4, 0.2, 0.2, 1.0);
	}
}
