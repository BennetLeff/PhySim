module mesh;

import std.stdio;
import derelict.opengl3.gl3;
import gl3n.gl3n.linalg;

class Mesh
{
    this(vec3[] vertices, int num_vertices)
    {
        draw_count = num_vertices;
          
        glGenVertexArrays(1, &vertex_array_object);
        glBindVertexArray(vertex_array_object);

        glGenBuffers(NUM_BUFFERS, vertex_array_buffers.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertex_array_buffers[POSITION_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vertices.sizeof, vertices.ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindVertexArray(0);
    }
    void draw()
    {
        glBindVertexArray(vertex_array_object);

        glDrawArrays(GL_TRIANGLES, 0, draw_count);

        glBindVertexArray(0);
    }
private:
    enum 
    {
        POSITION_VB,
        NUM_BUFFERS
    };

    GLuint vertex_array_object;
    GLuint vertex_array_buffers[NUM_BUFFERS];
    int draw_count;
}
