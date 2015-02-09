module shader;

import std.stdio;
import std.string;
import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

class Shader
{
    this(string file_name)
    {
        // Load OpenGL versions 1.0 and 1.1.
        DerelictGL3.load();
        // Load versions 1.2+ and all supported ARB and EXT extensions.
        DerelictGL3.reload();

        program = glCreateProgram();

        shaders[0] = create_shader(load_shader(file_name ~ ".vs"), GL_VERTEX_SHADER);
        //shaders[1] = create_shader(load_shader(file_name ~ ".fs"), GL_FRAGMENT_SHADER);

        for (int i = 0; i < NUM_SHADERS; i++)
            glAttachShader(program, shaders[i]);

        glBindAttribLocation(program, 0, "position"); 

        glLinkProgram(program);

        check_shader_error(program, GL_COMPILE_STATUS, false, "Error linking shader!");

        glValidateProgram(program);

        check_shader_error(program, GL_COMPILE_STATUS, false, "Error invalid shader!");


        if (glGenVertexArrays == null)
        {
            writeln("gl gen vertex arrays is missing in shader"); // chances are you don't have this feature...
        }
    }
    void bind()
    {
        glUseProgram(program);
    }
    string load_shader(string shader_name) {
        string output;
        auto f = File(shader_name);         // open file for reading,
        scope(exit) f.close();              //   and close the file when we're done.
                                            //   (optional)
        foreach (str; f.byLine)             // read every line in the file,
            output ~= str;
	    writeln(output);
        return output;                      //   and return it
    }
    GLuint create_shader(string text, GLenum shader_type)
    {
        GLuint shader = glCreateShader(shader_type);

        GLchar* shader_source_strings[1];
        GLint shader_source_strings_lengths[1];

        shader_source_strings[0] = cast(char*)(text);
        shader_source_strings_lengths[0] = (cast(int)text.length);

        glShaderSource(shader, 1, shader_source_strings.ptr, shader_source_strings_lengths.ptr);
        glCompileShader(shader);

        check_shader_error(shader, GL_COMPILE_STATUS, false, "Error compiling shader!");

        return shader;
    }
    void check_shader_error(GLuint shader, GLuint flag, bool isProgram, string error_message)
    {
        GLint success = 0;
        GLchar[1024] error;

        if (isProgram)
            glGetProgramiv(shader, flag, &success);
        else
            glGetShaderiv(shader, flag, &success);

        if (success == GL_FALSE)
        {
            if(isProgram)
                glGetProgramInfoLog(shader, error.sizeof, null, error.ptr);
            else
                glGetProgramInfoLog(shader, error.sizeof, null, error.ptr);
            writeln(error_message ~ error ~ "\n");
        }
    }
private:
    static const int NUM_SHADERS = 1;
    GLuint program;
    GLuint shaders[NUM_SHADERS];
}
