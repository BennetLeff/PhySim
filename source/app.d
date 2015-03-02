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
    Prefab model2 = new Prefab(new ObjLoader("./res/cubetextured.obj").loadMeshFile(), new Texture("./res/bill.jpeg"));

    auto models = [model, model2];

    transform.setPos(vec3(0, 0, -10));

    model.transform = transform;
    model2.transform = new Transform();

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        model.transform.setRot(vec3(0.0, counter, 0.0));
        model.transform.setPos(vec3(0, 5 * sin(counter), 0));

        model2.transform.setRot(vec3(counter, 0.0, 0.0));
        model2.transform.setPos(vec3(5 * sin(counter), 0, 0));

        foreach(m; models)
            m.renderInstance(camera);

        disp.update();
        counter += 0.05f;
    }
}
