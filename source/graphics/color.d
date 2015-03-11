module graphics.color;

import std.stdio;
import core;

class Color
{
	this(float r, float g, float b, float a)
	{
		this.r = r / 255;
		this.g = g / 255;
		this.b = b / 255;
		this.a = a / 255;
		colorArray = [this.r, this.g, this.b, this.a];
	}
	this(float r, float g, float b)
	{
		this.r = r / 255;
		this.g = g / 255;
		this.b = b / 255;
		this.a = 1.0;
		colorArray = [this.r, this.g, this.b, this.a];
	}
	float[] byArray()
	{
		colorArray[0] = r;
		colorArray[1] = g;
		colorArray[2] = b;
		colorArray[3] = a;
		return colorArray;
	}
	vec3 byVec()
	{
		return vec3(r, g, b);
	}

public:
	float r;
	float g;
	float b;
	float a;
	float[] colorArray;
}