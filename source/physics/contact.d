module physics.contact;

import core;
import physics;
import std.stdio;

class Contact
{
    this(RigidBody r1, RigidBody r2, float restitution)
    {
        this.rigidBodies = [r1, r2];
        this.restitution = restitution;
    }
    void resolve(float dur, vec3 contactNormal)
    {
        resolveVelocity(dur, contactNormal);
        resolvePenetration(dur, contactNormal);
    }

    float calcSeperatingVelocity(vec3 contactNormal)
    {
        vec3 relVelocity = rigidBodies[0].vel;

        writeln("rigidBodies[0].vel ", rigidBodies[0].vel);

        if (rigidBodies[1])
        {
            relVelocity -= rigidBodies[1].vel;
        }
        // return dot product of these two vectors
        writeln("relVelocity ,contactNormal ", relVelocity, " ", contactNormal);
        return relVelocity * contactNormal;
    }

    private void resolveVelocity(float dur, vec3 contactNormal)
    {
        float seperatingVel = calcSeperatingVelocity(contactNormal);

        writeln("sep vel ", seperatingVel);

        if (seperatingVel > 0)
        {
            return;
        }

        float newSepVel = -seperatingVel * restitution;
        writeln("newSepVel ", -seperatingVel, " * ", restitution, " = ", newSepVel);
        float deltaVel = newSepVel - seperatingVel;

        float totalInverseMass = 1.0 / rigidBodies[0].mass;
        if (rigidBodies[1])
        {
            totalInverseMass += 1.0 / rigidBodies[1].mass;
        }

        if (totalInverseMass <= 0)
        {
            return;
        }

        float impulse = deltaVel / totalInverseMass;
        vec3 impulsePerIMass = contactNormal * impulse;

        writeln("impulse per mass ", impulsePerIMass);

        rigidBodies[0].vel += impulsePerIMass * (1.0 / rigidBodies[0].mass);

        if (rigidBodies[1])
        {
            rigidBodies[1].vel += impulsePerIMass * -(1.0 / rigidBodies[1].mass);
        }

        writeln("r1, r2, imp ", rigidBodies[0].vel, ", ", rigidBodies[1].vel, ", ", impulse);
    }

    void resolvePenetration(float dur, vec3 contactNormal)
    {
        if (penetrationDepth <= 0)
        {
            return;
        }
        
        float totalInverseMass = rigidBodies[0].mass;

        if (rigidBodies[1])
        {
            totalInverseMass += rigidBodies[1].mass;
        }

        if (totalInverseMass <= 0)
        {
            return;
        }

        vec3 movePerIMass = contactNormal * (-penetrationDepth / totalInverseMass);

        rigidBodies[0].pos += movePerIMass * rigidBodies[0].mass;

        if (rigidBodies[1])
        {
            rigidBodies[1].pos += movePerIMass * rigidBodies[1].mass;
        }

        writeln("rbody mass, ", rigidBodies[0].mass, ", ", rigidBodies[1].mass);
        writeln("rbody pos, ", rigidBodies[0].pos, ", ", rigidBodies[1].pos);
    }
private:
    RigidBody rigidBodies[2];
    float restitution;
    float penetrationDepth;
    vec3 contactNormal;
}