module core.prefab;

import core;
import graphics;

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
		asset.shader = new Shader("./res/basicShader");
		asset.texture = new Texture("./res/bricks.jpg");
		//asset.mesh = new ObjLoader("./res/cubetextured.obj").loadMeshFile();
	}
	this(Asset asset)
	{
		this.asset = asset;
	}
	this(Mesh mesh)
	{
		asset.mesh = mesh;
		asset.texture = null;
		asset.shader = new Shader("./res/basicShader");
	}
	this(Mesh mesh, Texture texture)
	{
		asset.mesh = mesh;
		asset.texture = texture;
		asset.shader = new Shader("./res/basicShader");
	}
	void renderInstance(Camera cam)
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