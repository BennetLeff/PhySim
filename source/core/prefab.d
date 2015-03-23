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
		pLights[0] = pL;
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
		pLights[0] = pL;
	}
	this(Mesh mesh, Texture texture)
	{
		asset.mesh = mesh;
		asset.texture = texture;
		asset.shader = new Shader("./res/basicShader");
		pL = new PointLight(col, pointLightPos);
		pLights[0] = pL;
	}
	void renderInstance(Camera cam)
	{
		asset.shader.bind();
		asset.shader.update(transform, cam, pLights);
		asset.texture.bind(0);
		asset.mesh.draw();
	}
private:
	Asset asset;
	PointLight pL;
	PointLight[1] pLights;
	vec3 pointLightPos = vec3(-1.0f, 0.0f, 0.0f);
	Color col = new Color(255, 255, 255);
public:
	Transform transform;
}