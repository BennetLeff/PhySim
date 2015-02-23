module texture;

import std.stdio;
import derelict.opengl3.gl3;
import derelict.sdl2.image;
import derelict.sdl2.sdl;

class Texture
{
  this(string file_name)
  {
    // Load the SDL2_image library.
    DerelictSDL2Image.load();

    IMG_Init( IMG_INIT_PNG | IMG_INIT_JPG );

    SDL_Surface* surface = IMG_Load(cast(const(char*))file_name);
    if (surface == null)
      writeln("Error: Texture loading failed");

    

    //ubyte* image_data = stbi_load_from_memory(cast(void[])file_name, width, height, num_components, 4);

    // gen space for one texture at GLuint texture
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    // texture wrapping
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    // handles texture if it takes too much space on screen
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    //writeln(surface.format.Rmask);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, surface.w, surface.h, 0, GL_RGB,
                  GL_UNSIGNED_BYTE, surface.pixels);

    SDL_FreeSurface(surface);
  }
  // unit determines which texture is bound
  // i.e. multi textures can be bound
  void bind(uint unit)
  {
    assert(unit >= 0 && unit <= 31, "Error: Attempting to bind too many textures");

    glActiveTexture(GL_TEXTURE0 + unit);
    glBindTexture(GL_TEXTURE_2D, texture);

  }
private:
  GLuint texture;
  int width, height, num_components;
}
