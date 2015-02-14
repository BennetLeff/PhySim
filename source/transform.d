module transform;

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
						.rotatex(1)
						.rotatey(1)
						.rotatez(1)
						.scale(scale.x, scale.y, scale.z);

		return m4fv;

		//mat4 pos_matrix = mat4.translate(pos.x, pos.y, pos.z);
		//mat4 rot_x_matrix = mat4.rotatex(1);
		//mat4 rot_y_matrix = mat4.rotatey(1);
		//mat4 rot_z_matrix = mat4.rotatez(1);
		//mat4 scale_matrix = mat4.scale(scale.x. scale.y, scale.z);

		//mat4 rot_matrix = rot_z_matrix * rot_y_matrix * rot_x_matrix;

		//return pos_matrix * rot_matrix * scale_matrix;
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