module meshloader;

import std.stdio;
import std.regex;
import std.string;
import std.container;
import std.conv;
import std.range;
import gl3n.gl3n.linalg;
import mesh;
import vertex;

// helpful code http://www.cplusplus.com/forum/general/105894/
struct IndexedModel
{
    vec3[] pos;
    vec3[] normals;
    vec2[] tex_coords;
}
class ObjLoader
{
	this(string file_name)
	{
		// currently checking if the file is an .obj
		if (!check_valid_file(file_name))
            this.file_name = file_name;
        else
            stderr.writeln(format("File format %s not supported", match(file_name, r".{1,3}$")));
    }
    bool check_valid_file(string file_name)
	{
		bool is_valid;
		return match(file_name, r".obj$") ? is_valid = true : is_valid = false;
	}
	Mesh load_mesh_file() {
        auto f = File(this.file_name);      // open file for reading,
        scope(exit) f.close();              //   and close the file when we're done.
                                            //   (optional)
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
                    if (!match(tokens[1], r"/\d/") && match(tokens[1], r"./"))
                    {    
                        indices.insert((to!uint(tokens[1].split("/")[0])));
                		indices.insert((to!uint(tokens[2].split("/")[0])));
                        indices.insert((to!uint(tokens[3].split("/")[0])));
                        uv_index.insert(1);
                        uv_index.insert(1);
                        uv_index.insert(1);
                    }
                    else if (match(tokens[1], r"/\d/"))
                    {   
                        indices.insert((to!uint(tokens[1].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[2].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[3].split("/")[0]) - 1));
                        // set second num after slash to texture vert
                        uv_index.insert(to!int(tokens[1].split("/")[1]));
                        uv_index.insert(to!int(tokens[2].split("/")[1]));
                        uv_index.insert(to!int(tokens[3].split("/")[1]));
                    }
                    else 
                    {
                        indices.insert((to!uint(tokens[1])));
                        indices.insert((to!uint(tokens[2])));
                        indices.insert((to!uint(tokens[3])));
                    }
                }
                else if (tokens[0] == "vn")
                {
                    normals.insert((to!float(tokens[1])) - 1);
                    normals.insert((to!float(tokens[2])) - 1);
                    normals.insert((to!float(tokens[3])) - 1);
                }
                else if (tokens[0] == "vt")
                {
                    temp_uvs.insert(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }
        //auto vertices = make_vert_array(vertices);
        auto indices = make_uint_array(indices);

        return new Mesh(make_indexed_model(), indices);
        //return null;
    }
    Vertex[] make_vert_array(Array!vec3 container_to_convert)
    {
        if (container_to_convert.length && temp_uvs[].array.length)
        {
            for (int i = 0; i < indices.length; i++)
            {
                temp_verts.insert(new Vertex(vertices.array[ indices[].array[i]], 
                                                 temp_uvs[].array[ uv_index[].array[i] - 1 ]));
            }
        }
        else
        {
            for (int i = 0; i < indices.length; i++)
            {    
                temp_verts.insert(new Vertex(vertices.array[indices.array[i] - 1]));
            }
        }
        return temp_verts.array;
    }
    uint[] make_uint_array(Array!uint container_to_convert)
    {
        return container_to_convert.array;
    }
    private IndexedModel make_indexed_model()
    {
        IndexedModel mod;
        
        for (int i = 0; i < indices.length; i++)
        {
            index_model_pos.insert(vertices.array[ indices[].array[i]]);
            index_model_tex.insert(temp_uvs[].array[ uv_index[].array[i] - 1 ]);
        }

        mod.pos = index_model_pos.array;
        mod.tex_coords = index_model_tex.array;

        return mod;
    }
private:
	auto vertices = make!(Array!vec3)();
	auto indices = make!(Array!uint)();
    auto normals = make!(DList!float)();
    auto uv_index = make!(DList!int)();
    auto temp_uvs = make!(DList!vec2)();
    auto index_model_pos = make!(Array!vec3)();
    auto index_model_tex = make!(Array!vec2)();
    auto temp_verts = make!(Array!Vertex)();
    string file_name;
}
