module graphics.meshloader;

import std.stdio;
import std.regex;
import std.string;
import std.container;
import std.conv;
import std.range;
import graphics;
import core;

struct IndexedModel
{
    vec3[] pos;
    vec3[] normals;
    vec2[] texCoords;
    uint[] indices;
}
class ObjLoader
{
	this(string fileName)
	{
		// currently checking if the file is an .obj
		if (!checkValidFile(fileName))
            this.fileName = fileName;
        else
            stderr.writeln(format("File format %s not supported", match(fileName, r".{1,3}$")));
    }
    bool checkValidFile(string fileName)
	{
		bool isValid;
		return match(fileName, r".obj$") ? isValid = true : isValid = false;
	}
	Mesh loadMeshFile() {
        auto f = File(this.fileName);      // open file for reading,
        scope(exit) f.close();              //   and close the file when we're done.
        foreach (str; f.byLine)             // read every line in the file,
        {
        	string[] tokens = cast(string[])str.split(" ");
            if (!(tokens.length == 0 || tokens[0] == "#"))
            {
            	if (tokens[0] == "v")
            	{
            		vertices.insert(vec3(to!float(tokens[1]),
            								 	to!float(tokens[2]),
            								 	to!float(tokens[3])));
            	}
            	else if (tokens[0] == "f")
            	{
                    if (tokens[1].split("/").length == 2)
                    {    
                        indices.insert((to!uint(tokens[1].split("/")[0]) - 1));
                		indices.insert((to!uint(tokens[2].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[3].split("/")[0]) - 1));

                        uvIndex.insert(to!int(tokens[1].split("/")[1]));
                        uvIndex.insert(to!int(tokens[2].split("/")[1]));
                        uvIndex.insert(to!int(tokens[3].split("/")[1]));
                    }
                    else if (tokens[1].split("/").length == 3)
                    {   
                        indices.insert((to!uint(tokens[1].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[2].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[3].split("/")[0]) - 1));
                        // set second num after slash to texture vert
                        uvIndex.insert(to!int(tokens[1].split("/")[1]));
                        uvIndex.insert(to!int(tokens[2].split("/")[1]));
                        uvIndex.insert(to!int(tokens[3].split("/")[1]));
                        // set third num to be normals
                        normalIndex.insert(to!int(tokens[1].split("/")[2]));
                        normalIndex.insert(to!int(tokens[2].split("/")[2]));
                        normalIndex.insert(to!int(tokens[3].split("/")[2]));
                        }
                    else 
                    {
                        indices.insert((to!uint(tokens[1]) - 1));
                        indices.insert((to!uint(tokens[2]) - 1));
                        indices.insert((to!uint(tokens[3]) - 1));
                    }
                }
                else if (tokens[0] == "vn")
                {
                    normals.insert(vec3(to!float(tokens[1]),
                                        to!float(tokens[2]),
                                        to!float(tokens[3])));
                }
                else if (tokens[0] == "vt")
                {
                    tempUVs.insert(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }

        if (tempUVs.length)
            return new Mesh(makeIndexedModel(vertices, tempUVs, normals, indices, uvIndex, normalIndex));
        else
        {
            IndexedModel mod = makeSimpleModel(vertices, normals, indices, normalIndex);
            return new Mesh(mod.pos, mod.indices);
        }
    }    
    private IndexedModel makeIndexedModel(Array!vec3 vertCont, Array!vec2 texCont, Array!vec3 normCont, Array!uint vertIndexCont, Array!int uvIndexCont, Array!int normIndexCont)
    {
        IndexedModel mod;
        
        mod.indices = vertIndexCont.array;
        auto vertArr = vertCont.array;
        auto uvIndexArr = uvIndexCont.array;
        auto texArr = texCont.array;
        auto normArr = normCont.array;
        for (int i = 0; i < vertIndexCont.length; i++)
        {
            indexModelPos.insert(vertArr[ vertIndexCont[i]]);
            if (normArr.length)
                indexModelNorm.insert(normArr[ normIndexCont[i] - 1]);
            if (uvIndex.length)
                indexModelTex.insert(texArr[ uvIndexArr[i] - 1 ]);
            if (i < indices.length)
                mod.indices[i] = i;
        }
        mod.pos = indexModelPos.array;
        mod.texCoords = indexModelTex.array;
        mod.normals = indexModelNorm.array;

        return mod;
    }
    private IndexedModel makeSimpleModel(Array!vec3 vertCont, Array!vec3 normCont, Array!uint vertIndexCont, Array!int normIndexCont)
    {
        IndexedModel mod;
        
        mod.indices = vertIndexCont.array;
        auto vertArr = vertCont.array;
        auto normArr = normCont.array;
        for (int i = 0; i < vertIndexCont.length; i++)
        {
            indexModelPos.insert(vertArr[ vertIndexCont[i] ]);
            if (normArr.length)
                indexModelNorm.insert(normArr[ normIndexCont[i] - 1]);
            if (i < mod.indices.length)
                mod.indices[i] = i;
        }
        mod.pos = indexModelPos.array;
        mod.normals = indexModelNorm.array;

        return mod;
    }
private:
	auto vertices = make!(Array!vec3)();
	auto indices = make!(Array!uint)();
    auto normals = make!(Array!vec3)();

    auto uvIndex = make!(Array!int)();
    auto tempUVs = make!(Array!vec2)();
    auto normalIndex = make!(Array!int)();

    auto indexModelPos = make!(Array!vec3)();
    auto indexModelNorm = make!(Array!vec3)();
    auto indexModelTex = make!(Array!vec2)();
    string fileName;
}