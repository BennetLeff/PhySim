import std.stdio;
import std.datetime;
import std.array;
import std.math;
import core;
import graphics;
import components;

import graphics.assimp;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;    
    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Transform transform = new Transform();

    Camera camera = new Camera(vec3(0, 0, -2), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    float counter = 0.0f;

    AssImp asset = new AssImp();

    Mesh m = asset.loadMesh("./res/monkey.obj");

    Prefab fab2 = new Prefab(m, new Texture("./res/bricks.jpg"));

    fab2.transform = new Transform();

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        fab2.transform.rot(vec3(0.0, counter / 3.0, 0.0));
        fab2.transform.pos(vec3(0.0, sin(counter / 5), 3));

        fab2.renderInstance(camera);

        disp.update();
        counter += 0.05f;
    }
}
