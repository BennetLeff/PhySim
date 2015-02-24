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
            		vertices.insertBack(new Vertex(vec3(to!float(tokens[1]),
            								 	to!float(tokens[2]),
            								 	to!float(tokens[3]))));
            	}
            	else if (tokens[0] == "f")
            	{
                    if (!match(tokens[1], r"/\d/") && match(tokens[1], r"./"))
                    {    
                        writeln("matched d1 ", tokens[1]); 
                        indices.insertBack((to!uint(tokens[1].split("/")[0])) - 1);
                		indices.insertBack((to!uint(tokens[2].split("/")[0])) - 1);
                        indices.insertBack((to!uint(tokens[3].split("/")[0])) - 1);
                        uv_index.insertBack(1);
                        uv_index.insertBack(1);
                        uv_index.insertBack(1);
                    }
                    else if (match(tokens[1], r"/\d/"))
                    {   
                        writeln("matched d2 ", tokens); 
                        indices.insertBack((to!uint(tokens[1].split("/")[0])) - 1);
                        indices.insertBack((to!uint(tokens[2].split("/")[0])) - 1);
                        indices.insertBack((to!uint(tokens[3].split("/")[0])) - 1);
                        // set second num after slash to texture vert
                        uv_index.insertBack(to!int(tokens[1].split("/")[1]));
                        uv_index.insertBack(to!int(tokens[2].split("/")[1]));
                        uv_index.insertBack(to!int(tokens[3].split("/")[1]));
                    }
                    else 
                    {
                        indices.insertBack((to!uint(tokens[1])) - 1);
                        indices.insertBack((to!uint(tokens[2])) - 1);
                        indices.insertBack((to!uint(tokens[3])) - 1);
                    }
                }
                else if (tokens[0] == "vn")
                {
                    normals.insertBack((to!float(tokens[1])) - 1);
                    normals.insertBack((to!float(tokens[2])) - 1);
                    normals.insertBack((to!float(tokens[3])) - 1);
                }
                else if (tokens[0] == "vt")
                {
                    temp_uvs.insertBack(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }
        auto vertices = make_vert_array(vertices);

        auto indices = make_uint_array(indices);
        return new Mesh(vertices, indices);                      //   and return it
    }
    Vertex[] make_vert_array(DList!Vertex container_to_convert)
    {
        if (container_to_convert[].array.length && temp_uvs[].array.length)
        {
            for (int i = 0; i < container_to_convert[].array.length; i++)
            {
                container_to_convert[].array[i].tex_coords = temp_uvs[].array[ uv_index[].array[i] - 1 ];
            }
        }
        else 
        {
            for (int i = 0; i < container_to_convert[].array.length; i++)
            {
                container_to_convert[].array[i].tex_coords = vec2(0.0, 0.0);
            }
        }
        return container_to_convert[].array;
    }
    uint[] make_uint_array(DList!uint container_to_convert)
    {
        return container_to_convert[].array;
    }
private:
	auto vertices = make!(DList!Vertex)();
	auto indices = make!(DList!uint)();
    auto normals = make!(DList!float)();
    auto uv_index = make!(DList!int)();
    auto temp_uvs = make!(DList!vec2)();
    auto tex_coords = make!(DList!vec2)();
    string file_name;
}
