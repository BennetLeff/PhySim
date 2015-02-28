module vertex;

import gl3n.gl3n.linalg;

class Vertex
{
    this(vec3 pos)
    {
        this.pos = pos;
        this.tex_coords = vec2(0, 0);
        this.normal = vec3(0.0, 0.0, 0.0);
    }
    this(vec3 pos, vec2 tex_coords)
    {
        this.pos = pos;
        this.tex_coords = tex_coords;
        this.normal = vec3(0.0, 0.0, 0.0);
    }
    this(vec3 pos, vec2 tex_coords, vec3 normal)
    {
        this.pos = pos;
        this.tex_coords = tex_coords;
        this.normal = normal;
    }
public:
    vec3 pos;
    vec2 tex_coords;
    vec3 normal;
}
