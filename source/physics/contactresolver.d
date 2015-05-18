module physics.contactresolver;

import core;
import physics;
import std.stdio;

class ContactResolver
{
    this(uint iterations)
    {
        this.iterations = iterations;
    }

    void setIterations(uint iterations)
    {
        iterations = iterations;
    }

    void resolveContacts(Contact[] contacts, uint numContacts, float dur, vec3 contactNormal)
    {
        iterationsUsed = 0;
        while(iterationsUsed < iterations)
        {
            float max = 0;
            uint maxIndex = numContacts; 

            for (uint i = 0; i < numContacts; i++)
            {
                float sepVal = contacts[i].calcSeperatingVelocity(contactNormal);

                if (sepVal < max)
                {
                    max = sepVal;
                    maxIndex = i;
                }
            }
            contacts[0].resolve(dur, contactNormal);
            iterationsUsed++;
        }
    }

    uint iterations;
    uint iterationsUsed;
}