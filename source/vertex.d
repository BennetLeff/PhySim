module vertex;

import gl3n.gl3n.linalg;

class Vertex
{
    this(vec3 pos)
    {
        this.pos = pos;
    }
private:
    vec3 pos;
}