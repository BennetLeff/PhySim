module graphics.vertex;

import core;

class Vertex
{
    this(vec3 pos)
    {
        this.pos = pos;
        this.texCoords = vec2(0, 0);
        this.normal = vec3(0.0, 0.0, 0.0);
    }
    this(vec3 pos, vec2 texCoords)
    {
        this.pos = pos;
        this.texCoords = texCoords;
        this.normal = vec3(0.0, 0.0, 0.0);
    }
    this(vec3 pos, vec2 texCoords, vec3 normal)
    {
        this.pos = pos;
        this.texCoords = texCoords;
        this.normal = normal;
    }
public:
    vec3 pos;
    vec2 texCoords;
    vec3 normal;
}
