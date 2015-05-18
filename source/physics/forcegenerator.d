module physics.forcegenerator;

import core;
import physics.rigidbody;


interface ForceGenerator
{
    void updateForce(RigidBody* rigidBody, float dur);
}
class ForceRegistry
{
    struct ForceRegistration
    {
        RigidBody* rigidBody;
        ForceGenerator* generator;
    }

    ForceRegistration[] forceRegis = [];

    void add(RigidBody* rigidBody, ForceGenerator* fg)
    {
        ForceRegistration registration;
        registration.rigidBody = rigidBody;
        registration.generator = fg;
        forceRegis ~= registration;
    }
    void clear()
    {
        forceRegis = [];
    }
    void updateForces(float dur)
    {
        foreach(fr; forceRegis)
        {
            fr.generator.updateForce(fr.rigidBody, dur);
        }
    }
}
class RigidBodyGravity : ForceGenerator
{
    this(vec3 gravity)
    {
        this.gravity = gravity;
    }
    override void updateForce(RigidBody* rigidBody, float dur)
    {
        if (rigidBody.applyGrav)
        {
            rigidBody.addForce(gravity * rigidBody.mass);
        }
    }
private:
    vec3 gravity;
}
// TO-DO 
class RigidBodyDrag : ForceGenerator
{
    // drag coefficients
    float k1;
    float k2;

    this(float k1, float k2)
    {
        k1 = k1;
        k2 = k2;
    }
    override void updateForce(RigidBody* rigidBody, float dur)
    {
        
    }
}