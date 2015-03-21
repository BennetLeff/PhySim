module core.prefab;

import core;
import graphics;
import components;

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
		pL = new PointLight(col, pointLightPos);
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
		pL = new PointLight(col, pointLightPos);
	}
	this(Mesh mesh, Texture texture)
	{
		asset.mesh = mesh;
		asset.texture = texture;
		asset.shader = new Shader("./res/basicShader");
		pL = new PointLight(col, pointLightPos);
	}
	void renderInstance(Camera cam)
	{
		asset.shader.bind();
		asset.shader.update(transform, cam, pL);
		asset.texture.bind(0);
		asset.mesh.draw();
	}
private:
	Asset asset;
	PointLight pL;
	vec3 pointLightPos = vec3(-1.0f, 0.0f, 0.0f);
	Color col = new Color(128f, 147f, 255f);
public:
	Transform transform;
}