module physics.collider;

import std.math;
import core;
import physics;

class Collider
{
    this(vec3 xyz, float vWidth, float vHeight, float vDepth)
    {
        this.bounds = xyz;
        this.volumeWidth = vWidth;
        this.volumeHeight = vHeight;
        this.volumeDepth = vDepth;
        this.volume = vec3(bounds.x + volumeWidth, bounds.y + volumeHeight, bounds.z + volumeDepth);
    }

    bool isPenetrating(Collider box)
    {
        return (abs(bounds.x - box.bounds.x) * 2 < (volumeWidth + box.width)) &&
               (abs(bounds.y - box.bounds.y) * 2 < (volumeHeight + box.height)) &&
               (abs(bounds.z - box.bounds.z) * 2 < (volumeDepth + box.depth));
    }

    @property ref vec3 pos() { return bounds; }
    @property ref vec3 pos(vec3 p) { return bounds = p; }
    @property ref float width() { return volumeWidth; }
    @property ref float width(float w) { return volumeWidth = w; }
    @property ref float height() { return volumeHeight; }
    @property ref float height(float h) { return volumeHeight = h; }
    @property ref float depth() { return volumeDepth; }
    @property ref float depth(float d) { return volumeDepth = d; }

    vec3 bounds;
    vec3 volume;

    float volumeWidth;
    float volumeHeight;
    float volumeDepth;
}