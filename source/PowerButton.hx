package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.system.FlxSound;
import flixel.FlxG;

class PowerButton extends WidgetSprite {

    public static var clickSound : FlxSound;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        clickSound = FlxG.sound.load("assets/sounds/click.ogg");
        loadFromPowered();
        givesPower = true;
        recievesPower = false;
        powerSource = true;
        important = true;
    }

    private function loadOff() {
        loadGraphic("assets/images/powerbutton.png");        
    }

    private function loadOn() {
        loadGraphic("assets/images/powerbutton_p.png");        
    }

    private function loadFromPowered() if(powered) loadOn() else loadOff();

    override private function mouseClickCallback(obj : FlxExtendedSprite, x : Int, y : Int) {
        clickSound.play(true);
        powered = !powered;
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        grid.inPlay = powered;
        return powered;
    }

}