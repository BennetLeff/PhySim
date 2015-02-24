module shader;

import std.stdio;
import std.string;
import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import gl3n.gl3n.linalg;
import transform;
import camera;

class Shader
{
    this(string file_name)
    {
        program = glCreateProgram();

        shaders[0] = create_shader(load_shader(file_name ~ ".vs"), GL_VERTEX_SHADER);
        shaders[1] = create_shader(load_shader(file_name ~ ".fs"), GL_FRAGMENT_SHADER);

        for (int i = 0; i < NUM_SHADERS; i++)
            glAttachShader(program, shaders[i]);

        glBindAttribLocation(program, 0, "position");
        glBindAttribLocation(program, 1, "tex_coord");

        glLinkProgram(program);
        check_shader_error(program, GL_LINK_STATUS, true, "Error linking shader!");

        glValidateProgram(program);
        check_shader_error(program, GL_VALIDATE_STATUS, true, "Error invalid shader!");
    
        uniforms[TRANSFORM_U] = glGetUniformLocation(program, "transform");
        uniforms[COLOR_U] = glGetUniformLocation(program, "color");

        if (glGetError())
        {
            write("Error in shader class: ");
            write(glGetError());
            write("\n");
        }
    }
    void update(Transform transform, Camera camera, float[] color)
    {
        mat4 model = camera.get_view_projection() * transform.get_model();
        glUniformMatrix4fv(uniforms[TRANSFORM_U], 1, GL_TRUE, model.value_ptr);
        glUniform1fv(uniforms[COLOR_U], 3, color.ptr);
    }
    void update(Transform transform, Camera camera)
    {
        mat4 model = camera.get_view_projection() * transform.get_model();
        glUniformMatrix4fv(uniforms[TRANSFORM_U], 1, GL_TRUE, model.value_ptr);
        glUniform1fv(uniforms[COLOR_U], 3, [1.0f, 0.0f, 0.0f].ptr);
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
        {
            output ~= str;
            output ~= "\n";
        }

	    ///writeln(output);
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
    static const int NUM_SHADERS = 2;
    GLuint program;
    GLuint shaders[NUM_SHADERS];
    GLuint uniforms[NUM_UNIFORMS];
    enum 
    {
        TRANSFORM_U,
        COLOR_U,
        NUM_UNIFORMS
    };
}
