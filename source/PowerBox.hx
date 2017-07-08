package;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class PowerBox extends WidgetSprite {

    private var sound : FlxSound;

    private var timer : FlxTimer;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        timer = new FlxTimer();
        sound = FlxG.sound.load("assets/sounds/powerbox.ogg");
    }

    private function loadFromPowered() {
        loadGraphic('assets/images/powerbox${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        if(powered) sound.play(false);
        loadFromPowered();
        if(powered && !timer.active){
            timer.start(1.5, function(timer : FlxTimer) {
                nextLevel();
            });
        }
        return powered;
    }

    override public function mouseDragCallback(enabled : Bool) {
        if(!enabled) {
            timer.cancel();
        } else {
            sound.stop();
        }
    }

    private function nextLevel() {
        if(powered) grid.loadNextMap();
    }

}