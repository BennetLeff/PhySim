module physics.contact;

import core;
import physics;
import std.stdio;
import std.conv; 

class Contact
{
    this(RigidBody r1, RigidBody r2, float restitution)
    {
        this.rigidBodies = [r1, r2];
        this.restitution = restitution;
        this.penetrationDepth = 1;
        this.logger = new Logger();
    }

    void resolve(float dur, vec3 contactNormal)
    {
        //resolveVel(dur, contactNormal);
        resolvePen(dur, contactNormal);

        //resolveVelocity(dur, contactNormal);
        //resolvePenetration(dur, contactNormal);
    }

    float calcSeperatingVelocity(vec3 contactNormal)
    {
        vec3 relVelocity = rigidBodies[0].vel;

        if (rigidBodies[1])
        {
            relVelocity -= rigidBodies[1].vel;
        }
        // return dot product of these two vectors
        return relVelocity * contactNormal;
    }

    private void resolveVelocity(float dur, vec3 contactNormal)
    {
        if ( true )//rigidBodies[0].canBounce)
        {
            float seperatingVel = calcSeperatingVelocity(contactNormal);
            if (seperatingVel > 0)
            {
                return;
            }

            float newSepVel = -seperatingVel * restitution;        
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

            rigidBodies[0].vel += impulsePerIMass * (1.0 / rigidBodies[0].mass);

            if (rigidBodies[1])
            {
                rigidBodies[1].vel += impulsePerIMass * -(1.0 / rigidBodies[1].mass);
            }
        }

        else 
        {
            //rigidBodies[0].vel = -rigidBodies[1].vel;
        }
    }

    private void resolveVel(float dur, vec3 contactNormal)
    {
        float mass = rigidBodies[0].mass;
        float dot = (rigidBodies[0].mass * rigidBodies[0].vel) * contactNormal;

        float j = max(- (1 + restitution) * dot, 0);
        rigidBodies[0].vel += j * contactNormal;
    }

    void resolvePenetration(float dur, vec3 contactNormal)
    {
        if ( true )//rigidBodies[0].canBounce)
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

            vec3 movePerIMass = -contactNormal * (-penetrationDepth / totalInverseMass);
            rigidBodies[0].pos -= movePerIMass * rigidBodies[0].mass;
            
            if (rigidBodies[1])
            {
                rigidBodies[1].pos -= movePerIMass * rigidBodies[1].mass;
                logger.log("contactNormal: " ~ contactNormal.toString, 0);
            }


        }

        else
        {
            //rigidBodies[0].pos += vec3(0, 0.1, 0);            
            //logger.log(contactNormal, 0);
        }
    }

    void resolvePen(float dur, vec3 contactNormal)
    {
        rigidBodies[0].pos += vec3(0, 0.25, 0);
    }

    vec3 penDepth()
    {
        return rigidBodies[1].pos - rigidBodies[0].pos;
    }
private:
    RigidBody rigidBodies[2];
    float restitution;
    float penetrationDepth;
    vec3 contactNormal;
    Logger logger;
}