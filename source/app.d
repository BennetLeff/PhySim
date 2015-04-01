import std.stdio;
import std.datetime;
import std.array;
import std.math;
import core;
import graphics;
import components;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;    
    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Transform transform = new Transform();

    Camera camera = new Camera(vec3(0, 0, -20), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    float counter = 0.0f;

    Mesh m = new MeshLoader().loadMesh("./res/monkey.obj");

    Prefab fab2 = new Prefab(m, new Texture("./res/bricks.jpg"));

    fab2.transform = new Transform();

    fab2.transform.pos(vec3(0.0, 0.0, 10));

    Input manager;

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        // currently just used to navigate scene
        manager = disp.getInputManager();

        // w
        if(manager.isKeyPressed(119))
        {
            camera.pos(vec3(camera.pos.x, camera.pos.y, camera.pos.z + 1));
        }
        // s
        if(manager.isKeyPressed(115))
        {
            camera.pos(vec3(camera.pos.x, camera.pos.y, camera.pos.z - 1));
        }
        // a
        if(manager.isKeyPressed(97))
        {
            camera.pos(vec3(camera.pos.x + 1, camera.pos.y, camera.pos.z));
        }
        // d
        if(manager.isKeyPressed(100))
        {
            camera.pos(vec3(camera.pos.x - 1, camera.pos.y, camera.pos.z));
        }
        // space
        if(manager.isKeyPressed(32))
        {
            camera.pos(vec3(camera.pos.x, camera.pos.y + 1, camera.pos.z));
        }
        // c
        if(manager.isKeyPressed(99))
        {
            camera.pos(vec3(camera.pos.x, camera.pos.y - 1, camera.pos.z));
        }

        fab2.transform.rot(vec3(0.0, counter / 3.0, 0.0));
        //fab2.transform.pos(vec3(sin(counter / 5), 0.0, 3));

        fab2.renderInstance(camera);

        disp.update();
        counter += 0.05f;
    }
}
