package;

import flixel.addons.plugin.FlxMouseControl;
import flixel.ui.FlxSpriteButton;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState {
	private var maxStage = 0;

	private var grid : Grid;

	override public function create() : Void {
		super.create();
		FlxG.plugins.add(new FlxMouseControl());
		FlxG.mouse.useSystemCursor = true;
		grid = new Grid();
		if(FlxG.save.data.maxStage != null) {
			grid.mapIndex = Std.int(FlxG.save.data.maxStage-1);	
		}
		add(grid);
		add(grid.sprites);
		var backButton = new FlxSpriteButton(0, 0, null, backToMenu);
		backButton.loadGraphic("assets/images/backbutton.png");
		add(backButton);
		grid.loadNextMap();
	}

	override public function update(elapsed : Float) : Void {
		super.update(elapsed);
		if(maxStage != grid.mapIndex) FlxG.save.flush();
		maxStage = Std.int(Math.max(maxStage, grid.mapIndex));
	}

	private function backToMenu() {
		FlxG.save.data.maxStage = maxStage;
		FlxG.switchState(new MenuState());
	}
}
