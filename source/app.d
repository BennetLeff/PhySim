import std.stdio;
import std.datetime;
import std.array;
import std.math;
import core;
import graphics;
import components;
import physics;

void main()
{
    const int WIDTH = 800;
    const int HEIGHT = 600;    
    Display disp = new Display(WIDTH, HEIGHT, "SDL Based Rendering Context");

    Transform transform = new Transform();

    Camera camera = new Camera(vec3(0, 0, -10), WIDTH, HEIGHT, 70.0f, 0.01f, 1000.0f);

    Mesh m = new MeshLoader().loadMesh("./res/monkey.obj");
    Mesh m2 = new MeshLoader().loadMesh("./res/cubetextured.obj");

    Prefab fab = new Prefab(m2, new Texture("./res/bricks.jpg"));
    Prefab fab2 = new Prefab(m, new Texture("./res/bricks.jpg"));

    fab.transform = new Transform();
    fab.transform.pos(vec3(0.0, -4.0, -2.0));
    
    fab2.transform = new Transform();
    fab2.transform.pos(vec3(0.0, 0.0, 20));
    
    double t = 0;
    double dt = 1.0 / 60.0;

    RigidBody rBody = new RigidBody(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0));
    RigidBody rBody2 = new RigidBody(fab.transform.pos, vec3(0.0, 0.0, 0.0));
    RigidBodyGravity grav = new RigidBodyGravity(vec3(0.0, -0.0981, 0.0));

    Collider coll = new Collider(fab.transform.pos, 2, 3, 4);
    Collider coll2 = new Collider(fab2.transform.pos, 1, 2, 3);

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        rBody.addForce(vec3(0, 0.09, 0));
        grav.updateForce(&rBody, cast(float)t);

        rBody.update(t);

        t += dt;
        
        coll.pos = fab.transform.pos;
        coll2.pos = fab2.transform.pos;
        
        fab2.transform.pos = rBody.pos;

        fab2.renderInstance(camera);
        fab.renderInstance(camera);

        Contact con = new Contact(rBody, rBody2, 1);

        if (coll.isPenetrating(coll2))
        {
            //writeln(coll.isPenetrating(coll2));
            //writeln(rBody.pos);
            //rBody.addForce(vec3(0, 1, 0));
            con.resolve(t, rBody.pos - rBody2.pos);

            writeln("called");
        }

        disp.update();
    }
}
