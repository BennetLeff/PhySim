module physics.collidecoarse;

import physics;
import std.container;


class CollideCoarse
{
    this()
    {
        auto collisionHeap = new BinaryHeap!(Array!(Collider))();
    }
} 