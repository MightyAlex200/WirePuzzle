package;

import flixel.util.FlxTimer;

class Battery extends WidgetSprite {

    public var activated = false;
    public var charged = false;

    public var checkTimer : FlxTimer;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadFromPowered();
        givesPower = true;
        blocksPower = true;
        checkTimer = new FlxTimer().start(0.5, timerFunction, 0);
    }

    private function loadFromPowered() {
        if(!charged) {
            loadGraphic("assets/images/battery.png");
        } else if(activated) {
            loadGraphic("assets/images/battery_p.png");
        } else {
            loadGraphic("assets/images/battery_c.png");
        }
    }

    private function timerFunction(timer : FlxTimer) {
        if(!charged) {
            if(powered) {
                charged = true;
            }
        } else {
            if(!powered) {
                activated = true;
            }
        }
        loadFromPowered();
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }

    override public function mouseDragCallback(enabled : Bool) {
        activated = false;
        charged = false;
        powered = false;
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        powered = powered || activated;
        blocksPower = !activated;
    }

}