import std.stdio;
import display;
import shader;
import mesh;
import gl3n.gl3n.linalg;

void main()
{

    auto vertices = [ vec3(-0.5, -0.5, 0), vec3(0, 0.5, 0), vec3(0.5, -0.5, 0)];

    Display disp = new Display(800, 600, "SDL Based Rendering Context");

    Shader shader = new Shader("./res/basic_shader");

    Mesh mesh = new Mesh(vertices, 3);//vertices.sizeof/vertices[0].sizeof);

    while(!disp.is_closed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);
        
        shader.bind();
        mesh.draw();
        
        disp.update();
    }    
}
