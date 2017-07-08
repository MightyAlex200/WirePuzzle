package;

import flixel.util.FlxTimer;
import flixel.FlxG;

class SmokeDetector extends WidgetSprite {

    public var timer : FlxTimer;
    private var smokeTouching = false;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadFromPowered();
        givesPower = true;
        recievesPower = false;
        powerSource = true;
        timer = new FlxTimer();
        timer.start(0.5, timerFunction, 0);
    }

    private function timerFunction(timer : FlxTimer) {
        if(smokeTouching != powered) powered = smokeTouching;
        smokeTouching = false;
    }

    private function loadFromPowered() {
        loadGraphic('assets/images/smokedetector${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        if(powered) FlxG.sound.play("assets/sounds/smokedetector.ogg");
        loadFromPowered();
        return powered;
    }
    
    override public function mouseDragCallback(enabled : Bool) {
        if(enabled) {
            powered = false;
            smokeTouching = false;
        }
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        for(sprite in grid.sprites) {
            if(Std.is(sprite, Teapot.Steam)) {
                if(FlxG.overlap(this, sprite)) {
                    smokeTouching = true;
                    break;
                }
            }
        }
    }

}