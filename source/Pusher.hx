package;

import flixel.math.FlxRect;
import flixel.FlxObject;
import flixel.FlxG;

class Pusher extends FlippableWidget {

    public var defaultX(default, null) : Float;
    public var defaultY(default, null) : Float;

    public var displacedObject : WidgetSprite;
    public var displacedObjectDefaultX : Float;
    public var displacedObjectDefaultY : Float;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        defaultX = x;
        defaultY = y;
        loadGraphic("assets/images/pusher.png");
        powerSource = true;
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        if(powered) {
            var bounds = new FlxRect(64, 64, FlxG.width-128, FlxG.height-128);
            velocity.x = 5 * (direction == FlxObject.LEFT ? -1 : 1);
            if(displacedObject == null) {
                for(sprite in grid.sprites) {
                    if(sprite.transparent) continue;
                    if(sprite.important) continue;
                    if(sprite == this) continue;
                    if(FlxG.overlap(this, sprite)) {
                        displacedObject = sprite;
                        displacedObjectDefaultX = displacedObject.x;
                        displacedObjectDefaultY = displacedObject.y;
                        FlxG.collide(this, displacedObject);
                    }
                }
            } else {
                FlxG.collide(this, displacedObject);
                if(bounds.intersection(displacedObject.rect).width == 0) {
                    stop();
                }
                for(sprite in grid.sprites) {
                    if(sprite.transparent) continue;
                    if(sprite == this) continue;
                    if(FlxG.overlap(displacedObject, sprite)) {
                        stop();
                        break;
                    }
                }
            }
            if(bounds.intersection(rect).width == 0) {
                stop();
            }
        }
    }

    override public function kill() {
        stop();
        super.kill();
    }

    override public function mouseDragCallback(enabled) {
        super.mouseDragCallback(enabled);
        if(enabled){
            cleanUp();
        } else {
            defaultX = x;
            defaultY = y;
        }
    }

    private function cleanUp() {
        powered = false;
        setPosition(defaultX, defaultY);
        if(displacedObject != null) {
            displacedObject.x = displacedObjectDefaultX;
            displacedObject.y = displacedObjectDefaultY;
        }
        stop();
        displacedObject = null;
    }

    public function stop() {
        velocity.x = 0;
        if(displacedObject != null) {        
            displacedObject.velocity.x = 0;
            displacedObject.alignToGrid(false);
            alignToGrid(false);
        }
    }

}