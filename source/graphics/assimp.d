module graphics.assimp;

import std.stdio, std.container, std.range;
import core, graphics;
import derelict.assimp3.assimp;

class AssImp
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
		
		//writeln("verts: ", model.pos);
		//writeln("normals: ", model.normals);
		//writeln("texCoords: ", model.texCoords);
		//writeln("indices: ", model.indices);

		return model;
	}
	Mesh loadMesh(const char* fileName)
	{
		const aiScene* scene = aiImportFile(fileName, aiProcessPreset_TargetRealtime_Fast | aiProcess_Triangulate | aiProcess_JoinIdenticalVertices);
		const aiMesh* mesh = scene.mMeshes[0];

		numVerts = mesh.mNumVertices;

		vertArray = new vec3[numVerts];
		normalArray = new vec3[numVerts];
		uvArray = new vec2[numVerts];
		int indexcount = 0;

		for (uint i = 0; i < mesh.mNumFaces; i++)
		{
			const aiFace face = mesh.mFaces[i];
			indexcount += face.mNumIndices;

			for (int j = 0; j < 3; j++)
			{
				aiVector3D uv = mesh.mTextureCoords[0][face.mIndices[j]];
				uvArr.insert(vec2(uv.x, uv.y));

				aiVector3D normal = mesh.mNormals[face.mIndices[j]];
				normalArr.insert(vec3(normal.x, normal.y, normal.z));

				aiVector3D pos = mesh.mVertices[face.mIndices[j]];
				vertArr.insert(vec3(pos.x, pos.y, pos.z));
			}
		}

		for (int z = 0; z < indexcount + 1; z++)
		{
			indices.insert(z);
		}

		//writeln(indices.array.length);
		return new Mesh(makeIndexedModel(vertArr.array, normalArr.array, uvArr.array, indices.array));		
	}
private:
	vec3 vertArray[];
	vec3 normalArray[];
	vec2 uvArray[];
	auto vertArr = make!(Array!vec3)();
	auto normalArr = make!(Array!vec3)();
	auto uvArr = make!(Array!vec2)();
	auto indices = make!(Array!uint)();
	int numVerts;
}