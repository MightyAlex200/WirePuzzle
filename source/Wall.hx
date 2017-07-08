package;

class Wall extends WidgetSprite {

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadGraphic("assets/images/wall.png");
        recievesPower = false;
    }

}