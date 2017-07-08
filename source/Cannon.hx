package;

import flixel.FlxG;

class Cannon extends FlippableWidget {

    public var ball : CannonBall;
    public var shot = false;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadGraphic("assets/images/cannon.png");
    }

    override public function set_powered(powered : Bool) {
        if(powered && !shot) {
            ball = new CannonBall(x, y, grid, false, flipX, this);
            grid.sprites.add(ball);
            FlxG.sound.play("assets/sounds/cannonshoot.ogg");
            shot = true;
        }

        return super.set_powered(powered);
    }

    override public function mouseDragCallback(enabled : Bool) {
        super.mouseDragCallback(enabled);
        if(!enabled) return;
        if(ball != null) ball.cleanUp();
        shot = false;
    }

}

class CannonBall extends FlippableWidget {

    public var thingsDisplaced : Array<WidgetSprite> = [];
    public var shooter : Cannon;

    override public function new(?X : Float, ?Y : Float, grid : Grid, canDrag : Bool, isRight : Bool, shooter : Cannon) {
        super(X/grid.cellSize, Y/grid.cellSize, grid, canDrag);
        canFlip = false;
        this.shooter = shooter;
        loadGraphic("assets/images/cannonball.png");
        velocity.x = 50 * (isRight ? 1 : -1);
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        for(sprite in grid.sprites) {
            if(sprite == this) continue;
            if(sprite == shooter) continue;
            if(!sprite.alive) continue;
            if(sprite.important) continue;
            if(!sprite.transparent) {
                if(FlxG.overlap(this, sprite)) {
                    thingsDisplaced.push(sprite);
                    FlxG.sound.play("assets/sounds/cannonhit.ogg");
                    sprite.kill();
                }
            }
        }
    }

    public function cleanUp() {
        for(widget in thingsDisplaced) {
            widget.revive();
        }
        grid.sprites.remove(this);
    }

}