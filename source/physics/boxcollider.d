module physics.boxcollider;

import physics.collider;
import std.math;

class BoxCollider : Collider
{
    this(vec3 pos, float vWidth, float vHeight, float vDepth)
    {
        super(pos);
        this.volumeWidth = vWidth;
        this.volumeHeight = vHeight;
        this.volumeDepth = vDepth;
        this.volume = vec3(position.x + volumeWidth, position.y + volumeHeight, position.z + volumeDepth);
    }

    bool isPenetrating(BoxCollider box)
    {
        return (abs(position.x - box.position.x) * 2 < (volumeWidth + box.width)) &&
               (abs(position.y - box.position.y) * 2 < (volumeHeight + box.height)) &&
               (abs(position.z - box.position.z) * 2 < (volumeDepth + box.depth));
    }

    @property ref vec3 pos() { return position; }
    @property ref vec3 pos(vec3 p) { return position = p; }
    @property ref float width() { return volumeWidth; }
    @property ref float width(float w) { return volumeWidth = w; }
    @property ref float height() { return volumeHeight; }
    @property ref float height(float h) { return volumeHeight = h; }
    @property ref float depth() { return volumeDepth; }
    @property ref float depth(float d) { return volumeDepth = d; }

    vec3 volume;

    float volumeWidth;
    float volumeHeight;
    float volumeDepth;

    alias isPenetrating = Collider.isPenetrating;
}