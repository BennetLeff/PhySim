module input;

import graphics;
import core;
import components;

class Input
{	
	void pressKey(uint keyID)
	{
		keyMap[keyID] = true;
	}
	void releaseKey(uint keyID)
	{
		keyMap[keyID] = false;
	}
	bool isKeyPressed(uint keyID)
	{
		if (keyID in keyMap)
			return true;
		else
			return false;
	}
private:
	bool[uint] keyMap;
}