module graphics.mesh;

import std.stdio;
import std.container;
import std.range;
import graphics;
import core;

class Mesh
{
    this(Vertex[] vertices, uint[] indices)
    {    
        drawCount = cast(int)indices.length;

        auto posList = Array!vec3();
        auto texCoordList = Array!vec2();

        for (uint i = 0; i < vertices.length; i++)
        {
            posList.insert(vertices[i].pos);
            texCoordList.insert(vertices[i].texCoords);
        }

        glGenVertexArrays(1, &vertexArrayObject);
        glBindVertexArray(vertexArrayObject);

        glGenBuffers(NUM_BUFFERS, vertexArrayBuffer.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[POSITION_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, (posList[].array).ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[TEXCOORD_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vec2.sizeof, (texCoordList[].array).ptr, GL_STATIC_DRAW);

        glEnableVertexAttribArray(1);
        glVertexAttribPointer(cast(GLuint)1, 2, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexArrayBuffer[INDEX_VB]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * indices.sizeof, indices.ptr, GL_STATIC_DRAW);

        glBindVertexArray(0);
    }
    this(vec3[] vertices, uint[] indices)
    {    
        drawCount = cast(int)indices.length;

        glGenVertexArrays(1, &vertexArrayObject);
        glBindVertexArray(vertexArrayObject);

        glGenBuffers(NUM_BUFFERS, vertexArrayBuffer.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[POSITION_VB]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, vertices.ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexArrayBuffer[INDEX_VB]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * indices.sizeof, indices.ptr, GL_STATIC_DRAW);

        glBindVertexArray(0);
    }
    this(IndexedModel indexedModel)
    {    
        drawCount = cast(int)indexedModel.indices.length;

        glGenVertexArrays(1, &vertexArrayObject);
        glBindVertexArray(vertexArrayObject);

        glGenBuffers(NUM_BUFFERS, vertexArrayBuffer.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[POSITION_VB]);
        glBufferData(GL_ARRAY_BUFFER, indexedModel.pos.length * vec3.sizeof, indexedModel.pos.ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[TEXCOORD_VB]);
        glBufferData(GL_ARRAY_BUFFER, indexedModel.texCoords.length * vec2.sizeof, indexedModel.texCoords.ptr, GL_STATIC_DRAW);

        glEnableVertexAttribArray(1);
        glVertexAttribPointer(cast(GLuint)1, 2, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glGenBuffers(NUM_BUFFERS, vertexArrayBuffer.ptr);
        glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer[NORMAL_VB]);
        glBufferData(GL_ARRAY_BUFFER, indexedModel.normals.length * vec3.sizeof, indexedModel.normals.ptr, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(cast(GLuint)2, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexArrayBuffer[INDEX_VB]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexedModel.indices.length * indexedModel.indices.sizeof, indexedModel.indices.ptr, GL_STATIC_DRAW);

        glBindVertexArray(0);
    }
    void draw()
    {
        glBindVertexArray(vertexArrayObject);

        glDrawElements(GL_TRIANGLES, drawCount, GL_UNSIGNED_INT, cast(const(void)*)0);

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
    GLuint vertexArrayObject;
    GLuint vertexArrayBuffer[NUM_BUFFERS];
    vec3 normals;
    int drawCount;
}