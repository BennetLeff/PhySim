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
    uint[] indices;
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

                        uv_index.insert(to!int(tokens[1].split("/")[1]));
                        uv_index.insert(to!int(tokens[2].split("/")[1]));
                        uv_index.insert(to!int(tokens[3].split("/")[1]));
                    }
                    else if (tokens[1].split("/").length == 3)
                    {   
                        indices.insert((to!uint(tokens[1].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[2].split("/")[0]) - 1));
                        indices.insert((to!uint(tokens[3].split("/")[0]) - 1));
                        // set second num after slash to texture vert
                        uv_index.insert(to!int(tokens[1].split("/")[1]));
                        uv_index.insert(to!int(tokens[2].split("/")[1]));
                        uv_index.insert(to!int(tokens[3].split("/")[1]));
                        // set third num to be normals
                        normal_index.insert(to!int(tokens[1].split("/")[2]));
                        normal_index.insert(to!int(tokens[2].split("/")[2]));
                        normal_index.insert(to!int(tokens[3].split("/")[2]));
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
                    temp_uvs.insert(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }

        if (temp_uvs.length)
            return new Mesh(make_indexed_model(vertices, temp_uvs, normals, indices, uv_index, normal_index));
        else
        {
            IndexedModel mod = make_simple_model(vertices, normals, indices, normal_index);
            return new Mesh(mod.pos, mod.indices);
        }
    }    
    private IndexedModel make_indexed_model(Array!vec3 vert_cont, Array!vec2 tex_cont, Array!vec3 norm_cont, Array!uint vert_index_cont, Array!int uv_index_cont, Array!int norm_index_cont)
    {
        IndexedModel mod;
        
        mod.indices = vert_index_cont.array;
        auto vert_arr = vert_cont.array;
        auto uv_index_arr = uv_index_cont.array;
        auto tex_arr = tex_cont.array;
        auto norm_arr = norm_cont.array;
        for (int i = 0; i < vert_index_cont.length; i++)
        {
            index_model_pos.insert(vert_arr[ vert_index_cont[i]]);
            if (norm_arr.length)
                index_model_norm.insert(norm_arr[ norm_index_cont[i] - 1]);
            if (uv_index.length)
                index_model_tex.insert(tex_arr[ uv_index_arr[i] - 1 ]);
            if (i < indices.length)
                mod.indices[i] = i;
        }
        mod.pos = index_model_pos.array;
        mod.tex_coords = index_model_tex.array;
        mod.normals = index_model_norm.array;

        return mod;
    }
    private IndexedModel make_simple_model(Array!vec3 vert_cont, Array!vec3 norm_cont, Array!uint vert_index_cont, Array!int norm_index_cont)
    {
        IndexedModel mod;
        
        mod.indices = vert_index_cont.array;
        auto vert_arr = vert_cont.array;
        auto norm_arr = norm_cont.array;
        for (int i = 0; i < vert_index_cont.length; i++)
        {
            index_model_pos.insert(vert_arr[ vert_index_cont[i] - 1]);
            if (norm_arr.length)
                index_model_norm.insert(norm_arr[ norm_index_cont[i] - 1]);
            if (i < mod.indices.length)
                mod.indices[i] = i;
        }
        mod.pos = index_model_pos.array;
        mod.normals = index_model_norm.array;

        return mod;
    }
private:
	auto vertices = make!(Array!vec3)();
	auto indices = make!(Array!uint)();
    auto normals = make!(Array!vec3)();

    auto uv_index = make!(Array!int)();
    auto temp_uvs = make!(Array!vec2)();
    auto normal_index = make!(Array!int)();

    auto index_model_pos = make!(Array!vec3)();
    auto index_model_norm = make!(Array!vec3)();
    auto index_model_tex = make!(Array!vec2)();
    string file_name;
}