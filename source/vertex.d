module vertex;

import gl3n.gl3n.linalg;

class Vertex
{
    this(vec3 pos)
    {
        this.pos = pos;
        this.tex_coords = vec2(0, 0);
    }
    this(vec3 pos, vec2 tex_coords)
    {
        this.pos = pos;
        this.tex_coords = tex_coords;
    }
public:
    vec3 pos;
    vec2 tex_coords;
}
