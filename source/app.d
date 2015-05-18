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

    Mesh m = new MeshLoader().loadMesh("./res/cubetextured.obj");
    Mesh m2 = new MeshLoader().loadMesh("./res/cubetextured.obj");

    Prefab fab = new Prefab(m2, new Texture("./res/bricks.jpg"));
    Prefab fab2 = new Prefab(m, new Texture("./res/bricks.jpg"));

    fab.transform = new Transform();
    fab.transform.pos(vec3(0.0, -4.0, 0));
    
    fab2.transform = new Transform();
    fab2.transform.pos(vec3(0.0, 2.0, 0));
    
    double t = 0;
    double dt = 1.0 / 60.0;

    RigidBody rBody = new RigidBody(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0));
    RigidBody rBody2 = new RigidBody(fab.transform.pos, vec3(0.0, 0.0, 0.0));
    RigidBodyGravity grav = new RigidBodyGravity(vec3(0.0, -0.0981, 0.0));

    BoxCollider coll = new BoxCollider(fab.transform.pos, 1, 1, 1);
    BoxCollider coll2 = new BoxCollider(fab2.transform.pos, 1, 1, 1);

    Contact con = new Contact(rBody, rBody2, 0.5);
    ContactResolver conRes = new ContactResolver(1);
    Contact[] conArr = [con];

    Logger log = new Logger();

    rBody.canBounce = true;

    while(!disp.isClosed())
    {
        disp.clear(0.1f, 0.2f, 0.3f, 1.0f);

        grav.updateForce(&rBody, cast(float)t);

        rBody.update(t);

        t += dt;
        
        coll.pos = fab.transform.pos;
        coll2.pos = fab2.transform.pos;
        
        fab2.transform.pos = rBody.pos;
        fab2.renderInstance(camera);
        fab.renderInstance(camera);

        if (coll.isPenetrating(coll2))
        {
            log.log("colliding", 0);
            conRes.resolveContacts(conArr, 1, t, rBody2.pos - rBody.pos);
        }
        log.log(rBody.pos.toString ~ " " ~ rBody.vel.toString ~ " " ~ rBody.accel.toString, 0);
        //log.logToCSV(t, fab2.transform.pos.y);

        disp.update();
    }
}
