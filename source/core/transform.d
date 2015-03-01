module core.transform;

import std.math;
import core;

class Transform
{
	this(vec3 pos, vec3 rot, vec3 scale)
	{
		this.pos = pos;
		this.rot = rot;
		this.scale = scale;
	}
	this()
	{
		this.pos = vec3(0.0f, 0.0f, 0.0f);
		this.rot = vec3(0.0f, 0.0f, 0.0f);
		this.scale = vec3(1.0f, 1.0f, 1.0f);
	}
	mat4 getModel () 
	{
		mat4 m4fv = mat4.translation(pos.x, pos.y, pos.z)
						.rotatex(rot.x * (PI/180))
						.rotatey(rot.y * (PI/180))
						.rotatez(rot.z * (PI/180))
						.scale(scale.x, scale.y, scale.z);

		return m4fv;
	}
	vec3 getPos () { return pos; }
	vec3 getRot () { return rot; }
	vec3 getScale () { return scale; }
	void setPos (vec3 p) { this.pos = p; }
	void setRot (vec3 r) { this.rot = r; }
	void setScale (vec3 s) { this.scale = s; }
private:
	vec3 pos;
	vec3 rot;
	vec3 scale;
}