module core.transform;

import std.math;
import core;

class Transform
{
	this(vec3 pos, vec3 rot, vec3 scale)
	{
		this.modPos = pos;
		this.modRot = rot;
		this.modScale = scale;
	}
	this()
	{
		this.modPos = vec3(0.0f, 0.0f, 0.0f);
		this.modRot = vec3(0.0f, 0.0f, 0.0f);
		this.modScale = vec3(1.0f, 1.0f, 1.0f);
	}
	mat4 getModel () 
	{
		return mat4.identity.rotatex(modRot.x)
                            .rotatey(modRot.y)
                            .rotatez(modRot.z)
                            .scale(modScale.x, modScale.y, modScale.z)
                            .translate(modPos.x, modPos.y, modPos.z);                            
	}
	@property ref vec3 pos () { return modPos; }
	@property ref vec3 rot () { return modRot; }
	@property ref vec3 scale () { return modScale; }
	@property ref vec3 pos (vec3 p) { return this.modPos = p; }
	@property ref vec3 rot (vec3 r) { return this.modRot = r; }
	@property ref vec3 scale (vec3 s) { return this.modScale = s; }
private:
	vec3 modPos;
	vec3 modRot;
	vec3 modScale;
}