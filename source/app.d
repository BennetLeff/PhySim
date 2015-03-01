import std.stdio;
import std.datetime;
import std.array;
import std.math;
import display;
import shader;
import mesh;
import gl3n.gl3n.linalg;
import transform;
import camera;
import meshloader;
import color;
import texture;
import vertex;
import prefab;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;    
    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Transform transform = new Transform();

    Camera camera = new Camera(vec3(0, 0, -10), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    float counter = 0.0f;

    Prefab model = new Prefab(new ObjLoader("./res/monkey.obj").load_mesh_file(), new Texture("./res/bricks.jpg"));

    auto models = [model];

    transform.set_pos(vec3(0, 0, 2));

    model.transform = transform;

    while(!disp.is_closed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        model.transform.set_rot(vec3(0.0, 180, 0.0));

        //writeln("pos: ", model.transform.get_model());

        foreach(m; models)
            m.render_instance(camera);

        disp.update();
        counter += 0.05f;
    }
}
