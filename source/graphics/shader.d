module graphics.shader;

import std.stdio;
import std.string;
import graphics;
import core;
import components;

class Shader
{
    this(string fileName)
    {
        program = glCreateProgram();

        shaders[0] = createShader(loadShader(fileName ~ ".vs"), GL_VERTEX_SHADER);
        shaders[1] = createShader(loadShader(fileName ~ ".fs"), GL_FRAGMENT_SHADER);

        for (int i = 0; i < NUM_SHADERS; i++)
            glAttachShader(program, shaders[i]);

        glBindAttribLocation(program, 0, "position");
        glBindAttribLocation(program, 1, "texCoord");
        glBindAttribLocation(program, 2, "normal");

        glLinkProgram(program);
        checkShaderError(program, GL_LINK_STATUS, true, "Error linking shader!");

        glValidateProgram(program);
        checkShaderError(program, GL_VALIDATE_STATUS, true, "Error invalid shader!");
    
        uniforms[TRANSFORM_U] = glGetUniformLocation(program, "transform");
        uniforms[CAMERA_U] = glGetUniformLocation(program, "camera");
        uniforms[COLOR_U] = glGetUniformLocation(program, "light.color");
        uniforms[LIGHT_POS_U] = glGetUniformLocation(program, "light.position");

        if (glGetError())
        {
            write("Error in shader class: ");
            write(glGetError());
            write("\n");
        }
    }
    void update(Transform transform, Camera camera, vec3 color)
    {
        glUniformMatrix4fv(uniforms[TRANSFORM_U], 1, GL_TRUE, transform.getModel().value_ptr);
        glUniformMatrix4fv(uniforms[CAMERA_U], 1, GL_TRUE, camera.getViewProjection().value_ptr);
        glUniform1fv(uniforms[COLOR_U], 3, color.value_ptr);
    }
    void update(Transform transform, Camera camera, PointLight pointLight)
    {
        glUniformMatrix4fv(uniforms[TRANSFORM_U], 1, GL_TRUE, transform.getModel().value_ptr);
        glUniformMatrix4fv(uniforms[CAMERA_U], 1, GL_TRUE, camera.getViewProjection().value_ptr);
        // lighting uniforms
        glUniform1fv(uniforms[LIGHT_POS_U], 3, pointLight.position.value_ptr);
        glUniform1fv(uniforms[COLOR_U], 3, pointLight.color.byArray().ptr);

    }
    void bind()
    {
        glUseProgram(program);
    }
    string loadShader(string shaderName) {
        string output;
        auto f = File(shaderName);         // open file for reading,
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
    GLuint createShader(string text, GLenum shaderType)
    {
        GLuint shader = glCreateShader(shaderType);

        GLchar* shaderSourceStrings[1];
        GLint shaderSourceStringsLengths[1];

        shaderSourceStrings[0] = cast(char*)(text);
        shaderSourceStringsLengths[0] = (cast(int)text.length);

        glShaderSource(shader, 1, shaderSourceStrings.ptr, shaderSourceStringsLengths.ptr);
        glCompileShader(shader);

        checkShaderError(shader, GL_COMPILE_STATUS, false, "Error compiling shader!");

        return shader;
    }
    void checkShaderError(GLuint shader, GLuint flag, bool isProgram, string errorMessage)
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
            writeln(errorMessage ~ error ~ "\n");
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
        CAMERA_U,
        COLOR_U,
        LIGHT_POS_U,
        NUM_UNIFORMS
    };
}
