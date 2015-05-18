module physics.spherecollider;

import physics.collider;

class SphereCollider : Collider
{
    this(vec3 pos, float radius)
    {
        super(pos);
        this.radius = radius;
    }

    float radius;
}