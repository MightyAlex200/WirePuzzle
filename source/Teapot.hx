package;

import flixel.util.FlxTimer;
import flixel.math.FlxRect;
import flixel.FlxObject;
import flixel.FlxG;

class Teapot extends FlippableWidget {

    public var steamTimer : FlxTimer;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadGraphic("assets/images/teapot.png");
        steamTimer = new FlxTimer();
        steamTimer.start(0.5, createSteam, 0);
    }

    private function checkForBurner() {
        for(sprite in grid.sprites) {
            if(sprite.y == y+64 && sprite.x == x) {
                if(Std.is(sprite, Burner)) {
                    return sprite;
                }
            }
        }
        return null;
    }

    private function createSteam(timer : FlxTimer) {
        if(!alive) return;
        var burner = checkForBurner();
        if(burner != null) {
            if(burner.powered) {
                new Steam(x+(width * (direction == FlxObject.LEFT ? -1 : 1)), y, grid, false);
            }
        }
    }

    override public function mouseDragCallback(enabled : Bool) {
        steamTimer.reset(0.5);
    }

}

class Steam extends WidgetSprite {

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X/grid.cellSize, Y/grid.cellSize, grid, canDrag);
        loadGraphic("assets/images/steam.png");
        velocity.y = -4;
    }

    public function cleanUp() {
        grid.sprites.remove(this);
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        var bounds = new FlxRect(63, 63, FlxG.width-126, FlxG.height-126);
        if(bounds.intersection(this.rect).width == 0) {
            cleanUp();
            return;
        }
        for(sprite in grid.sprites) {
            if(sprite.transparent) continue;
            if(sprite == this) continue;
            if(Std.is(sprite, Steam)) continue;
            if(y - sprite.y < 16) {
                if(FlxG.overlap(this, sprite)) {
                    cleanUp();
                }
            }
        }
    }

    override public function mouseDragCallback(enabled) {
        if(enabled) {
            cleanUp();
        }
    }

}