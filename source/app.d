import std.stdio;
import display;
import shader;
import mesh;
import vertex;
import gl3n.gl3n.linalg;

void main()
{

    Vertex v1 = new Vertex(vec3(-0.5, -0.5, 0));
    Vertex v2 = new Vertex(vec3(0, 0.5, 0));
    Vertex v3 = new Vertex(vec3(0.5, -0.5, 0));
    
    Vertex* vertices = [v1, v2, v3].ptr; 

    Display disp = new Display(800, 600, "SDL Based Rendering Context");

    Shader shader = new Shader("./res/basic_shader");

    Mesh mesh = new Mesh(vertices, 3);//vertices.sizeof/vertices[0].sizeof);

    TutFile tut = new TutFile();

    while(!disp.is_closed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);
        
        shader.bind();
        mesh.draw();
        
        disp.update();
    }
    tut.main(800, 600, "SDL Based Rendering Context");
    
}
