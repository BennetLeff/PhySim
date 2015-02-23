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
                    if (match(tokens[1], r"\d/"))
                    {    
                        indices.insertBack((to!uint(tokens[1].split("/")[1])) - 1);
                		indices.insertBack((to!uint(tokens[2].split("/")[1])) - 1);
                        indices.insertBack((to!uint(tokens[3].split("/")[1])) - 1);
                    }
                    else if (match(tokens[1], r"\d/\d"))
                    {    
                        indices.insertBack((to!uint(tokens[1].split("/")[1])) - 1);
                        indices.insertBack((to!uint(tokens[2].split("/")[1])) - 1);
                        indices.insertBack((to!uint(tokens[3].split("/")[1])) - 1);
                        // set third num after slash to texture vert
                        //tex_coords.insertBack((to!float(tokens[1].split("/")[3])) - 1);
                        //tex_coords.insertBack((to!float(tokens[2].split("/")[3])) - 1);
                        //tex_coords.insertBack((to!float(tokens[3].split("/")[3])) - 1);
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
                    tex_coords.insertBack(vec2(to!float(tokens[1]), to!float(tokens[2])));
                }
            }
        }
        auto vertices = make_vert_array(vertices);

        auto indices = make_uint_array(indices);
        return new Mesh(vertices, indices);                      //   and return it
    }
    Vertex[] make_vert_array(DList!Vertex container_to_convert)
    {
        if (tex_coords[].array.length)
        {
            int i = 0;
            auto coords = tex_coords[].array;
            foreach (vert; vertices)
            {
                if (i >= coords.length)
                {
                    writeln("Warning: ", "More vertices than texture coordinates in OBJ file.");
                    break;
                }
                vert.tex_coords = coords[i];
                i++;
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
    auto tex_coords = make!(DList!vec2)();
    string file_name;
}
