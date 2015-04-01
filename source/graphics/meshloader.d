module graphics.meshloader;

import std.stdio, std.container, std.range;
import core, graphics;
import derelict.assimp3.assimp;

struct IndexedModel
{
    vec3[] pos;
    vec3[] normals;
    vec2[] texCoords;
    uint[] indices;
}

class MeshLoader
{
	this()
	{
		DerelictASSIMP3.load();
	}
	IndexedModel makeIndexedModel(vec3[] verts, vec3[] norms, vec2[] uvs, uint[] indices)
	{
		IndexedModel model;
		model.pos = verts;
		model.normals = norms;
		model.texCoords = uvs;
		model.indices = indices;
		
		return model;
	}
	Mesh loadMesh(const char* fileName)
	{
		const aiScene* scene = aiImportFile(fileName, aiProcessPreset_TargetRealtime_Fast | aiProcess_Triangulate | aiProcess_JoinIdenticalVertices);
		const aiMesh* mesh = scene.mMeshes[0];

		numVerts = mesh.mNumVertices;

		for(int i = 0; i < mesh.mNumVertices; i++)
		{
			aiVector3D vert = mesh.mVertices[i];
			vertArray ~= vec3(vert.x, vert.y, vert.z);

			//if (mesh.HasTextureCoords())
			//{
				aiVector3D uvw = mesh.mTextureCoords[0][i];
				uvArray ~= vec2(uvw.x, uvw.y);
			//}

			//if (mesh.HasNormals())
			//{
				aiVector3D n = mesh.mNormals[i];
				normalArray ~= vec3(n.x, n.y, n.z);
			//}
		}

		
		for(int i = 0; i < mesh.mNumFaces; i++)
		{
			const aiFace face = mesh.mFaces[i];
			
			indices ~= face.mIndices[0];
			indices ~= face.mIndices[1];
			indices ~= face.mIndices[2];
		}

		return new Mesh(makeIndexedModel(vertArray, normalArray, uvArray, indices));		
	}
private:
	vec3 vertArray[] = [];
	vec3 normalArray[] = [];
	vec2 uvArray[] = [];
	uint[] indices = [];

	int numVerts;
}