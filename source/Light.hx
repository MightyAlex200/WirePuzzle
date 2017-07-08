package;

class Light extends WidgetSprite {

    private function loadFromPowered() {
        loadGraphic('assets/images/light${powered ? "_p" : ""}.png');
    }

    override public function set_powered(powered : Bool) {
        super.set_powered(powered);
        loadFromPowered();
        return powered;
    }

}