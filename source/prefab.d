module prefab;

import mesh;
import meshloader;
import texture;
import shader;
import transform;
import camera;
import derelict.opengl3.gl3;

struct Asset
{
	Shader shader;
	Texture texture;
	Mesh mesh;
}
class Prefab
{
	this()
	{
		asset.shader = new Shader("./res/basic_shader");
		asset.texture = new Texture("./res/bricks.jpg");
		asset.mesh = new ObjLoader("./res/cubetextured.obj").load_mesh_file();
	}
	this(Asset asset)
	{
		this.asset = asset;
	}
	this(Mesh mesh)
	{
		asset.mesh = mesh;
		asset.texture = null;
		asset.shader = new Shader("./res/basic_shader");
	}
	this(Mesh mesh, Texture texture)
	{
		asset.mesh = mesh;
		asset.texture = texture;
		asset.shader = new Shader("./res/basic_shader");
	}
	void render_instance(Camera cam)
	{
		asset.shader.bind();
		asset.shader.update(transform, cam);
		asset.texture.bind(0);
		asset.mesh.draw();
	}
private:
	Asset asset;
public:
	Transform transform;
}