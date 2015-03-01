module transform;

import std.math;
import gl3n.gl3n.linalg;

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
	mat4 get_model () 
	{
		mat4 m4fv = mat4.translation(pos.x, pos.y, pos.z)
						.rotatex(rot.x * (PI/180))
						.rotatey(rot.y * (PI/180))
						.rotatez(rot.z * (PI/180))
						.scale(scale.x, scale.y, scale.z);

		return m4fv;
	}
	vec3 get_pos () { return pos; }
	vec3 get_rot () { return rot; }
	vec3 get_scale () { return scale; }
	void set_pos (vec3 p) { this.pos = p; }
	void set_rot (vec3 r) { this.rot = r; }
	void set_scale (vec3 s) { this.scale = s; }
private:
	vec3 pos;
	vec3 rot;
	vec3 scale;
}