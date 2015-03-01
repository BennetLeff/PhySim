module graphics.color;
import std.stdio;

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
	// takes a string r, g, b, or a and returns it's val
	// as an array
	// useful for OpenGL shader uniforms
	float[] rgbaByArray(string rgba)
	{
		if (rgba == "r")
			return [r];
		else if (rgba == "g") 
			return [g];
		else if (rgba == "b") 
			return [b];
		else if (rgba == "a") 
			return [a];
		return [0];
	}
	float[] byArray()
	{
		colorArray[0] = r;
		colorArray[1] = g;
		colorArray[2] = b;
		colorArray[3] = a;
		return colorArray;
	}
public:
	float r;
	float g;
	float b;
	float a;
	float[] colorArray;
}