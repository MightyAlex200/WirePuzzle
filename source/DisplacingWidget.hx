package;

interface DisplacingWidget {
    public var displacedObject : WidgetSprite;
    public var displacedObjectDefaultX : Float;
    public var displacedObjectDefaultY : Float;
    private function cleanUp() : Void;
}