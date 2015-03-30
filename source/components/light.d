module components.light;

import components;
import core;
import graphics;

class Light : Component
{
	this (Color col)
	{
		color = col;
	}
public:
	Color color;
}

class PointLight : Light
{
	this(Color col, vec3 pos)
	{
		super (col);
		this.position = pos;
		intensities = col.byVec();
		atten = [0.2f];
		ambCoefficient = [0.005f];
	}

	vec3 position;
	vec3 intensities;
	float[] atten;
	float[] ambCoefficient;

	@property ref vec3 pos () { return position; }
	@property ref vec3 intensity () { return intensities; }
	@property ref vec3 pos (vec3 p) { return this.position = p; }
	@property ref vec3 intensity (vec3 i) { return this.intensities = i; }

	@property ref float[] attenuation () { return this.atten; }
	@property ref float[] attenuation (float[] att) { return this.atten = att; }
	@property ref float[] ambientCoefficient () { return this.ambCoefficient; }
	@property ref float[] ambientCoefficient (float[] amb) { return this.ambCoefficient = amb; }
}