package;

import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxG;

class MenuState extends FlxState {
    private static var marginSize(default, never) = 16;

	override public function create() : Void {
		super.create();
        bgColor = FlxColor.WHITE;
		FlxG.mouse.useSystemCursor = true;
        var logo = new FlxSprite(0, 0, "assets/images/logo.png");
        logo.x = FlxG.width/2-logo.width/2;
        var playbutton = createNewButton("assets/images/playbutton.png", switchToPlayState, logo);
        createNewButton("assets/images/formatbutton.png", clearSaveData, playbutton);
        add(logo);
	}

    private function createNewButton(graphic : String, ?callback : Void->Void, lastAsset : FlxObject) {
        var newButton = new FlxButton(0, 0, "", callback);
        newButton.loadGraphic(graphic);
        newButton.x = FlxG.width/2-newButton.width/2;
        newButton.y = lastAsset.y + lastAsset.height + marginSize;
        add(newButton);
        return newButton;
    }

    private static function clearSaveData() {
        FlxG.save.erase();
    }

    private static function switchToPlayState() {
        FlxG.switchState(new PlayState());
    }
}
