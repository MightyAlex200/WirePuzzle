package;

class Burner extends WidgetSprite {

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool) {
        super(X, Y, grid, canDrag);
        loadFromPowered();
    }

    private function loadFromPowered() {
        loadGraphic('assets/images/burner${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }

}