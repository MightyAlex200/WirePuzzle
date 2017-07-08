package;

import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
	}
}
