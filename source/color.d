module color;
import std.stdio;

class Color
{
	this(float r, float g, float b, float a)
	{
		this.r = r / 255;
		this.g = g / 255;
		this.b = b / 255;
		this.a = a / 255;
		color_array = [this.r, this.g, this.b, this.a];
	}
	this(float r, float g, float b)
	{
		this.r = r / 255;
		this.g = g / 255;
		this.b = b / 255;
		this.a = 1.0;
		color_array = [this.r, this.g, this.b, this.a];
	}
	// takes a string r, g, b, or a and returns it's val
	// as an array
	// useful for OpenGL shader uniforms
	float[] return_rgba_by_array(string rgba)
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
	float[] return_by_array()
	{
		color_array[0] = r;
		color_array[1] = g;
		color_array[2] = b;
		color_array[3] = a;
		return color_array;
	}
public:
	float r;
	float g;
	float b;
	float a;
	float[] color_array;
}