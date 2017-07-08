package;

interface MovingWidget {
    public var defaultX(default, null) : Float;
    public var defaultY(default, null) : Float;
    public function stop() : Void;
    private function cleanUp() : Void;
}