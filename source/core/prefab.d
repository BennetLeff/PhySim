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
		pL2 = new PointLight(col2, pointLightPos2);
		pLights[0] = pL;
		pLights[1] = pL2;
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
		pL2 = new PointLight(col2, pointLightPos2);
		pLights[0] = pL;
		pLights[1] = pL2;
	}
	this(Mesh mesh, Texture texture)
	{
		asset.mesh = mesh;
		asset.texture = texture;
		asset.shader = new Shader("./res/basicShader");
		pL = new PointLight(col, pointLightPos);
		pL2 = new PointLight(col2, pointLightPos2);
		pLights[0] = pL;
		pLights[1] = pL2;
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
	PointLight pL2;
	PointLight[2] pLights;
	vec3 pointLightPos = vec3(-20.0f, 0.0f, 0.0f);
	Color col = new Color(0, 0, 255);
	vec3 pointLightPos2 = vec3(20.0f, 0.0f, 0.0f);
	Color col2 = new Color(0, 255, 0);
public:
	Transform transform;
}