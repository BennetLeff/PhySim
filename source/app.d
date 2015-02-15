import std.stdio;
import display;
import shader;
import mesh;
import gl3n.gl3n.linalg;
import transform;
import camera;
import meshloader;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;

    auto vertices = [ vec3(-0.5, -0.5, 0), vec3(0, 0.5, 0), vec3(0.5, -0.5, 0)];

    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Shader shader = new Shader("./res/basic_shader");

    uint indices[] = [0, 1, 2];

    Mesh mesh = new Mesh(vertices, indices);

    Transform transform = new Transform();

    Transform tr2 = new Transform(vec3(0, 0, 0), vec3(0, 0, 0), vec3(1, 1, 1));

    Camera camera = new Camera(vec3(0, 0, -3), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    float counter = 0.0f;

    Mesh cube = new ObjLoader("./res/cube.obj").load_mesh_file();

    while(!disp.is_closed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);
        
        transform.set_pos(vec3(sin(counter / 10), 0, 0));
        transform.set_rot(vec3(0, 0, sin(counter / 10)));

        shader.bind();
        shader.update(transform, camera);
        //mesh.draw();
        cube.draw();
        disp.update();
        counter += 0.1f;
    }    
}
