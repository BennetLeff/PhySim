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
	Color color;
}

class PointLight : Light
{
	this(Color col, vec3 pos)
	{
		super (col);
		this.position = pos;
		intensities = col.byVec();
	}

	vec3 position;
	vec3 intensities;

	@property ref vec3 pos () { return position; }
	@property ref vec3 intensity () { return intensities; }
	@property ref vec3 pos (vec3 p) { return this.position = p; }
	@property ref vec3 intensity (vec3 i) { return this.intensities = i; }
}