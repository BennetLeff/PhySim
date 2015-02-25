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
            		vertices.insertBack(vec3(to!float(tokens[1]),
            								 	to!float(tokens[2]),
            								 	to!float(tokens[3])));
            	}
            	else if (tokens[0] == "f")
            	{
                    if (!match(tokens[1], r"/\d/") && match(tokens[1], r"./"))
                    {    
                        writeln("matched d1 ", tokens[1]); 
                        indices.insertBack((to!uint(tokens[1].split("/")[0])));
                		indices.insertBack((to!uint(tokens[2].split("/")[0])));
                        indices.insertBack((to!uint(tokens[3].split("/")[0])));
                        uv_index.insertBack(1);
                        uv_index.insertBack(1);
                        uv_index.insertBack(1);
                    }
                    else if (match(tokens[1], r"/\d/"))
                    {   
                        writeln("matched d2 ", tokens); 
                        indices.insertBack((to!uint(tokens[1].split("/")[0])));
                        indices.insertBack((to!uint(tokens[2].split("/")[0])));
                        indices.insertBack((to!uint(tokens[3].split("/")[0])));
                        // set second num after slash to texture vert
                        uv_index.insertBack(to!int(tokens[1].split("/")[1]));
                        uv_index.insertBack(to!int(tokens[2].split("/")[1]));
                        uv_index.insertBack(to!int(tokens[3].split("/")[1]));
                        //writeln("tokens[1].split(/): ", tokens[1].split("/")[1], tokens[2].split("/")[1], tokens[3].split("/")[1]);
                    }
                    else 
                    {
                        indices.insertBack((to!uint(tokens[1])));
                        indices.insertBack((to!uint(tokens[2])));
                        indices.insertBack((to!uint(tokens[3])));
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
                    //writeln("tokens[1], [2] ", tokens[1], " ", tokens[2]);
                    ///writeln("tokens[2] ", tokens[2]);
                    temp_uvs.insertBack(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }
        auto vertices = make_vert_array(vertices);

        auto indices = make_uint_array(indices);
        return new Mesh(vertices, indices);                      //   and return it
        //return new Mesh([new Vertex(vec3(0.0, 1.0, 0.5))], [1]);
    }
    Vertex[] make_vert_array(DList!vec3 container_to_convert)
    {
        if (container_to_convert[].array.length && temp_uvs[].array.length)
        {
            int j;
            int i;
            /*
            for (j = 0; j < indices[].array.length; j++)
            {
                //writeln("uvs: ", uv_index[].array[j]);
            }
            writeln(j);
            for (i = 0; i < container_to_convert[].array.length; i++)
            {
                container_to_convert[].array[i].tex_coords = temp_uvs[].array[ uv_index[].array[i] - 1 ];
                
                //writeln("tex_coords: ", container_to_convert[].array[i].tex_coords);
            }
            writeln(i);
            */
            //writeln("vertex array: ", vertices[].array);
            //writeln("indices array: ", indices[].array);
            //writeln("uvs array: ", temp_uvs[].array);
            writeln("uv index: ", uv_index[].array);
            writeln("indices: ", indices[].array);
            for (i = 0; i < indices[].array.length; i++)
            {
                //writeln("indices index: ", indices[].array[i]);
                //writeln("vertices: ", vertices[].array[ indices[].array[i] ]);
                //writeln("tex coords: ", temp_uvs[].array[ uv_index[].array[i] - 1 ]);

                // making a list of Vertices with vert and tex coords at their indexs of uv's and indices
                temp_verts.insertBack(new Vertex(vertices[].array[ indices[].array[i]  - 1 ], 
                                                 temp_uvs[].array[ uv_index[].array[i] - 1 ]));           
            }
        }
        else 
        {
            for (int i = 0; i < container_to_convert[].array.length; i++)
            {
                //container_to_convert[].array[i].tex_coords = vec2(0.0, 0.0);
            }
        }
        return temp_verts[].array;
    }
    uint[] make_uint_array(DList!uint container_to_convert)
    {
        return container_to_convert[].array;
    }
private:
	auto vertices = make!(DList!vec3)();
	auto indices = make!(DList!uint)();
    auto normals = make!(DList!float)();
    auto uv_index = make!(DList!int)();
    auto temp_uvs = make!(DList!vec2)();
    auto tex_coords = make!(DList!vec2)();
    auto temp_verts = make!(DList!Vertex)();
    string file_name;
}
