package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxObject;
import flixel.FlxG;

class FlippableWidget extends WidgetSprite {

    public var canFlip = true;

    public var playFlipSound = true;

    public var direction = FlxObject.LEFT;

    override private function mouseClickCallback(obj : FlxExtendedSprite, x : Float, y : Float) {
        flip();
    }

    public function flip() {
        if(canFlip) {
            direction = direction == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
            flipX = direction != FlxObject.LEFT;
            if(playFlipSound) FlxG.sound.play("assets/sounds/click.ogg");
        }
    }

    override public function mouseDragCallback(enabled : Bool) {
        canFlip = enabled;
    }

}