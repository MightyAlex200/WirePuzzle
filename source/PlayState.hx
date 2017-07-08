package;

import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState {
	override public function create() : Void {
		super.create();
		FlxG.plugins.add(new FlxMouseControl());
		FlxG.mouse.useSystemCursor = true;
		var myGrid = new Grid();
		add(myGrid);
		add(myGrid.sprites);
		myGrid.loadNextMap();
	}

	override public function update(elapsed : Float) : Void {
		super.update(elapsed);
	}
}
