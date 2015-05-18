module core.logger;

import std.stdio;
import std.file;

class Logger
{
    this()
    {
        f = File("data.csv", "w+");
    }
    
    this(string filename)
    {
        f = File(filename, "w+");
    }

    void log(T)(T msg, int flag)
    {
        if (flag == WARNING)
        {
            writefln("Warning: %s", msg);
        }
        else if (flag == ERROR)
        {
            writefln("Error: %s", msg);
        }
        else if (flag == NONE)
        {
            writefln("%s", msg);
        }
    }

    void logToCSV(T, T2)(T val, T2 val2)
    {   
        f.writefln("%s,%s", val, val2);
    }

    public enum
    {
        WARNING = 1,
        ERROR = 2,
        NONE = 0,
        EMPTY = -1
    }
private:
    File f;
}