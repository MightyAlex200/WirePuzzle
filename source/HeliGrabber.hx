package;

import flixel.util.FlxTimer;
import flixel.math.FlxRect;
import flixel.FlxG;

class HeliGrabber extends WidgetSprite implements MovingWidget {

    public var defaultX(default, null) : Float;
    public var defaultY(default, null) : Float;

    public var displacedObject : WidgetSprite;
    public var displacedObjectDefaultX : Float;
    public var displacedObjectDefaultY : Float;

    public var goingBackwards = false;

    private var gripping = false;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        defaultX = x;
        defaultY = y;
        loadGraphic("assets/images/heligrabber.png", true, 64, 64);
        animation.add("loose", [0, 1, 2], 2, true);
        animation.add("grip", [3, 4, 5], 2, true);
        animation.add("idle", [0], 1, false);
        powerSource = true;
        loadFromPowered();
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        var bounds = new FlxRect(64, 64, FlxG.width-128, FlxG.height-128);
        if(powered) velocity.y = 10 * (goingBackwards ? -1 : 1);
        if(displacedObject != null) displacedObject.velocity.y = velocity.y;
        if(powered) {
            if(displacedObject == null) {
                for(sprite in grid.sprites) {
                    if(sprite.transparent) continue;
                    if(sprite.important) continue;
                    if(sprite == this) continue;
                    if(FlxG.collide(this, sprite)) {
                        displacedObject = sprite;
                        displacedObjectDefaultX = displacedObject.x;
                        displacedObjectDefaultY = displacedObject.y;
                        goingBackwards = true;
                    }
                }
            } else {
                FlxG.collide(this, displacedObject);
                for(sprite in grid.sprites) {
                    if(sprite.transparent) continue;
                    if(sprite == this) continue;
                    if(sprite == displacedObject) continue;
                    if(FlxG.overlap(displacedObject, sprite) || FlxG.overlap(this, sprite)) {
                        stop();
                        break;
                    }
                }
            }
        }
        var rect = rect;
        rect.y += velocity.y;
        if(bounds.intersection(rect).width == 0) {
            stop();
        }
    }

    private function loadFromPowered() {
        if(powered) if(gripping) animation.play("grip") else animation.play("loose"); else animation.play("idle");
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }

    override public function mouseDragCallback(enabled : Bool) {
        powered = !enabled;
        if(enabled) {
            cleanUp();
        }
    }

    public function stop() {
        velocity.y = 0;
        alignToGrid(false);
        if(displacedObject != null) {
            displacedObject.velocity.y = 0;
            displacedObject.alignToGrid(false);
        }
    }

    public function cleanUp() {
        x = defaultX;
        y = defaultY;
        if(displacedObject != null) {
            displacedObject.x = displacedObjectDefaultX;
            displacedObject.y = displacedObjectDefaultY;
        }
        stop();
        displacedObject = null;
        goingBackwards = false;
    }

}