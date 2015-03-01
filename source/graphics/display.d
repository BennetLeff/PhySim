module graphics.display;

import std.stdio;
import std.string;
import graphics;

class Display
{
    this()
    {
        DerelictSDL2.load();
    }
    this(int width, int height, const char* title)
    {

        // Load OpenGL versions 1.0 and 1.1.
        DerelictGL3.load();

        // Load SDL2
        DerelictSDL2.load();
        // Initialize SDL2
        SDL_Init(SDL_INIT_EVERYTHING);
        // Set attributes and create window
        SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 16);


        window = SDL_CreateWindow(title, 0, 0, width, height,
                                         SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);

        glContext = SDL_GL_CreateContext(window);

        isDisplayClosed = false;

        // Load versions 1.2+ and all supported ARB and EXT extensions.
        DerelictGL3.reload();

        glEnable(GL_DEPTH_TEST);

    }
    void update()
    {
        SDL_GL_SwapWindow(window);

        SDL_Event e;
        
        while(SDL_PollEvent(&e))
        {
            if (e.type == SDL_QUIT)
            {
                isDisplayClosed = true;
            }
        }
        
    }
    bool isClosed()
    {
        return isDisplayClosed;
    }
    void clear(float r, float g, float b, float a)
    {
        glClearColor(r, g, b, a);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
private:
    SDL_Window* window;
    SDL_GLContext glContext;
    bool isDisplayClosed;
}
