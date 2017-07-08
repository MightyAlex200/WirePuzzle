package;

class SolarPanel extends WidgetSprite {

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        recievesPower = false;
        givesPower = true;
    }

    private function loadFromPowered() {
        loadGraphic('assets/images/solarpanel${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        for(sprite in grid.sprites) {
            if(Std.is(sprite, Light) && sprite.powered) {
                if(sprite.x == x || sprite.y == y) {
                    for(wall in grid.sprites) {
                        if(!wall.transparent && wall != this && wall != sprite && (wall.x == x || wall.y == y) && wall.alive) {
                            var spriteAlignedX = sprite.x == x;
                            var wallAlignedX = wall.x == x;
                            var wallMightBeBlocking = spriteAlignedX == wallAlignedX;
                            if(!wallMightBeBlocking) continue;
                            var distanceToWall = wallAlignedX ? y - wall.y : x - wall.x;
                            var distanceToLight = spriteAlignedX ? y - sprite.y : x - sprite.x;
                            if(Math.abs(distanceToWall) < Math.abs(distanceToLight) && distanceToWall/Math.abs(distanceToWall) == distanceToLight/Math.abs(distanceToLight)) {
                                powered = false;
                                return;
                            }
                        }
                    }
                    powered = true;
                    break;
                }
            }
        }
    }

}