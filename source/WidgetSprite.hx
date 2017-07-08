package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.math.FlxRect;
import flixel.FlxG;

class WidgetSprite extends FlxExtendedSprite {

    @:isVar public var powered(get, set) = false;

    public var blocksPower = false;
    public var givesPower = false;
    public var recievesPower = true;
    public var powerSource = false;
    public var important = false;

    public var canDrag(default, null) = true;
    
    public var grid(default, set) : Grid;

    public var transparent = false;

    private var lastThisX : Float = 0;
    private var lastThisY : Float = 0;

    override public function new(?X : Float, ?Y : Float, grid : Grid, canDrag = true) {
        if(X != null) X *= grid.cellSize;
        if(Y != null) Y *= grid.cellSize;
        super(X,Y);
        enableMouseClicks(true);
        draggable = canDrag;
        this.canDrag = canDrag;
        this.grid = grid;
        grid.add(this);
        mousePressedCallback = function(obj : FlxExtendedSprite, x : Int, y : Int) {
            lastThisX = this.x;
            lastThisY = this.y;
        }
        mouseReleasedCallback = function(obj : FlxExtendedSprite, x : Int, y : Int) {
            if(!powered) {
                // enableMouseSnap does not work as intended so I have to make it myself lol
                var myRect = new FlxRect(this.x+16, this.y+16, 32, 32);
                for(sprite in grid.sprites) {
                    if(sprite == this) continue;
                    var sprRect = new FlxRect(sprite.x+16, sprite.y+16, 32, 32);
                    if(myRect.overlaps(sprRect) && !sprite.transparent) {
                        this.x = lastThisX;
                        this.y = lastThisY;
                        FlxG.sound.play("assets/sounds/cantmove.ogg");
                        trace('Colliding with $sprite');
                    }
                }
                alignToGrid(!(lastThisX == this.x && lastThisY == this.y));
            }
            if(Math.abs(lastThisX - this.x) < 10 && Math.abs(lastThisY - this.y) < 10) {
                mouseClickCallback(obj, x, y);
            }
        }
        powered = false;
        lastThisX = x;
        lastThisY = y;
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        var blockingSprite : WidgetSprite = null;
        if(recievesPower) {
            for(sprite in grid.sprites) {
                if(sprite.blocksPower) {
                    if(FlxG.overlap(this,sprite)) {
                        blockingSprite = sprite;
                        break;
                    }
                }
            }
            for(sprite in grid.sprites){
                if(sprite.powered && sprite.givesPower) {
                    if(FlxG.overlap(this, sprite)) {
                        var doBlock = false;
                        if(blockingSprite != null){
                            doBlock = this.rect.intersection(sprite.rect).intersection(blockingSprite.rect).width != 0;
                        }
                        if(!doBlock) {
                            powered = true;
                        }
                        break;
                    }
                }
            }
        }
    }

    public function set_grid(grid : Grid) {
        boundsSprite = grid;
        return this.grid = grid;
    }

    public function get_powered() {
        return this.powered;
    }

    public function set_powered(powered : Bool) {
        return this.powered = powered;
    }

    // override public function enableMouseDrag(lockCenter : Bool = false, pixelPerfect : Bool = false, alphaThreshold : Int = 255, ?boundsRect : FlxRect, ?boundsSprite : FlxSprite) {
    //     super.enableMouseDrag(lockCenter, pixelPerfect, alphaThreshold, boundsRect, boundsSprite);
    //     mouseDragCallback(true);
    // }

    override public function disableMouseDrag() {
        super.disableMouseDrag();
        mouseDragCallback(false);
    }

    public function mouseDragCallback(enabled : Bool) {}

    public function alignToGrid(playsound = true) {
        if(playsound) FlxG.sound.play("assets/sounds/pop.ogg");
        x = Math.round(x/64)*64;
        y = Math.round(y/64)*64;
    }

    private function mouseClickCallback(obj : FlxExtendedSprite, x : Int, y : Int) {}

}