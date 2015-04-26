module physics.rigidbody;

import core;
import physics.integrator;

class RigidBody : State
{
    this(vec3 pos, vec3 vel)
    {
        super(pos, vel);
        forceSum = vec3(0.0, 0.0, 0.0);
        inverseMass = 1;
    }
    override 
    {
        void update(double dt)
        {
            accel = vec3(0, 0, 0);
            
            vec3 resultantAccel = accel;
            resultantAccel += forceSum * inverseMass;

            vec3 oldVel = velocity;
            velocity = velocity + resultantAccel * dt;
            position = position + (velocity + oldVel) * 0.5 * dt;

            clearForces();
        }
    }
    void addForce(vec3 force)
    {
        forceSum += force;
    }
    void clearForces()
    {
        forceSum = vec3(0.0, 0.0, 0.0);
    }
    @property ref float mass() { return inverseMass; }
    @property ref float mass(float m) { return inverseMass = m; }
private:
    float inverseMass;
    vec3 forceSum;
}