module mesh;

import std.stdio;
import std.container;
import std.range;
import vertex;
import derelict.opengl3.gl3;
import gl3n.gl3n.linalg;

class Mesh
{
    this(Vertex[] vertices, uint[] indices)
    {    
        draw_count = cast(int)indices.length;

        auto pos_list = DList!vec3();
        auto tex_coord_list = DList!vec2();

        for (uint i = 0; i < vertices.length; i++)
        {
            pos_list.insert(vertices[i].pos);
            tex_coord_list.insert(vertices[i].tex_coords);
        }

        glGenVertexArrays(1, &vertex_array_object);
        glBindVertexArray(vertex_array_object);

        glGenBuffers(NUM_BUFFERS, vertex_array_buffers.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertex_array_buffers[POSITION_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, (pos_list[].array).ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ARRAY_BUFFER, vertex_array_buffers[TEXCOORD_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vec2.sizeof, (tex_coord_list[].array).ptr, GL_STATIC_DRAW);

        glEnableVertexAttribArray(1);
        glVertexAttribPointer(cast(GLuint)1, 2, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertex_array_buffers[INDEX_VB]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * indices.sizeof, indices.ptr, GL_STATIC_DRAW);

        glBindVertexArray(0);
    }
    void draw()
    {
        glBindVertexArray(vertex_array_object);

        glDrawElements(GL_TRIANGLES, draw_count, GL_UNSIGNED_INT, cast(const(void)*)0);

        //glDrawElementsBaseVertex(GL_TRIANGLES, draw_count, GL_UNSIGNED_INT, cast(const(void)*) 0, cast(const(void)*) 0);

        glBindVertexArray(0);
    }
private:
    enum 
    {
        POSITION_VB,
        TEXCOORD_VB,
        NORMAL_VB,
        INDEX_VB,
        NUM_BUFFERS = 4
    };
    GLuint vertex_array_object;
    GLuint vertex_array_buffers[NUM_BUFFERS];
    vec3 normals;
    int draw_count;
}