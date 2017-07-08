package;

class Wire extends WidgetSprite {

    public var horizontal = true;

    override public function new(?X : Float, ?Y : Float, grid : Grid, ?canDrag : Bool, horizontal = true) {
        super(X, Y, grid, canDrag);
        this.horizontal = horizontal;
        loadFromPowered();
        givesPower = true;
        transparent = true;
    }

    private function loadFromPowered() {
        loadGraphic('assets/images/wire${horizontal ? "hor" : "vert"}${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }
}