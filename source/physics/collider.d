module physics.collider;

import std.math;
public import core;

class Collider
{
    this(vec3 pos)
    {
        this.position = pos;
    }

    bool isPenetrating(Collider coll)
    {
        return false;
    }

    public vec3 position;
}