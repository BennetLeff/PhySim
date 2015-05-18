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
        bounce = false;
        hasGrav = true;
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

    void clearTorque()
    {
        // will be implemented once torque is implemented
    }

    void clearAccumulators()
    {
        clearForces();
        clearTorque();
    }

    @property ref vec3 forces() { return forceSum; }
    @property ref float mass() { return inverseMass; }
    @property ref float mass(float m) { return inverseMass = m; }
    @property ref bool canBounce() { return bounce; }
    @property ref bool canBounce(bool b) { return bounce = b; }
    @property ref bool applyGrav() { return hasGrav; }
    @property ref bool applyGrav(bool g) { return hasGrav = g; }
private:
    float inverseMass;
    bool bounce;
    bool hasGrav;
    vec3 forceSum;
    quat orientation;
}