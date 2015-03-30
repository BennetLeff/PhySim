module core.input;

import graphics;
import core;
import components;

struct Input
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
			return keyMap[keyID];
		else
			return false;
	}
	
	bool[uint] keyMap;
}