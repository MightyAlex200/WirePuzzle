package;

import flixel.FlxObject;
import flixel.FlxG;

class LevelSelectState extends MenuState {

    override public function create() {
        super.create();
        clear();
        var lastObject = new FlxObject(0, 0, 0, 0);
        for(level in Grid.maps) {
            var levelIndex = Grid.maps.indexOf(level) + 1;
            lastObject = createNewButton(Std.string(levelIndex), function() {
                FlxG.save.data.maxStage = levelIndex;
                FlxG.switchState(new PlayState());
            }, lastObject);
        }
    }

}