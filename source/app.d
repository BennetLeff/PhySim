import std.stdio;
//mport core.math;
import display;
import shader;
import mesh;
import gl3n.gl3n.linalg;
import transform;

void main()
{

    auto vertices = [ vec3(-0.5, -0.5, 0), vec3(0, 0.5, 0), vec3(0.5, -0.5, 0)];

    Display disp = new Display(800, 600, "SDL Based Rendering Context");

    Shader shader = new Shader("./res/basic_shader");

    Mesh mesh = new Mesh(vertices, 3);

    Transform transform = new Transform();

    float counter = 0.0f;

    while(!disp.is_closed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);
        
        transform.set_pos(vec3(sin(counter / 10), 0, 0));
        transform.set_rot(vec3(0, 0, sin(counter / 10)));
        transform.set_scale(vec3(cos(counter), cos(counter), cos(counter)));

        shader.bind();
        shader.update(transform);
        mesh.draw();
        
        disp.update();
        counter += 0.1f;
    }    
}
