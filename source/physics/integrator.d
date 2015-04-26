module physics.integrator;

import std.stdio;
import core;

class State
{
    vec3 accel;
    vec3 velocity;
    vec3 position; 
    
    this(vec3 pos, vec3 vel)
    {
        this.vel = vel;
        this.pos = pos;
        this.accel = vec3(0, 0, 0);
    }
    void update(double dt)
    {
        accel = vec3(0, 0, 0);
        vec3 oldVel = velocity;
        velocity = velocity + accel * dt;
        position = position + (velocity + oldVel) * 0.5 * dt;
    }
    @property ref vec3 vel () { return velocity; }
    @property ref vec3 pos () { return position; }
    @property ref vec3 vel (vec3 v) { return velocity = v; }
    @property ref vec3 pos (vec3 p) { return position = p; }

}