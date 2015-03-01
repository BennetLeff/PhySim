module graphics.camera;

import core;

class Camera
{
	this(vec3 pos, const int height, const int width, float fov, float zNear, float zFar)
	{
		perspective = mat4.perspective(width, height, fov, zNear, zFar);
		position = pos;
		forward = vec3(0, 0, 1);
		up = vec3(0, 1, 0);
	}
	mat4 getViewProjection()
	{
		return perspective * mat4.look_at(position, position + forward, up);
	}
private:
	mat4 perspective;
	vec3 position;
	vec3 forward;
	vec3 up;
}