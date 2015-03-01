import std.stdio;
import std.datetime;
import std.array;
import std.math;
import core;
import graphics;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;    
    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Transform transform = new Transform();

    Camera camera = new Camera(vec3(0, 0, -10), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    float counter = 0.0f;

    Prefab model = new Prefab(new ObjLoader("./res/monkey.obj").loadMeshFile(), new Texture("./res/bricks.jpg"));

    auto models = [model];

    transform.setPos(vec3(0, 0, 2));

    model.transform = transform;

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        model.transform.setRot(vec3(0.0, 180, 0.0));

        foreach(m; models)
            m.renderInstance(camera);

        disp.update();
        counter += 0.05f;
    }
}
