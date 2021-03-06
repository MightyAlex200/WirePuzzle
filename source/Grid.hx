package;

import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;

class Grid extends FlxExtendedSprite {

    public var inPlay(default, set) = false;

    public var sprites = new FlxTypedGroup<WidgetSprite>();

    public static var maps = [
        // "assets/data/maps/debug.tmx",
        "assets/data/maps/level1.tmx",
        "assets/data/maps/level2.tmx",
        "assets/data/maps/level3.tmx",
        "assets/data/maps/level4.tmx",
        "assets/data/maps/level5.tmx",
        "assets/data/maps/level6.tmx",
        "assets/data/maps/level7.tmx",
        "assets/data/maps/level8.tmx",
    ];

    public var mapIndex = 0;

    public var cellSize : Int;
    
    override public function new(?X : Float, ?Y : Float, cellSize = 64) {
        super(X,Y);
        this.cellSize = cellSize;
        loadGraphic("assets/images/background.png");
    }

    public function add(sprite : WidgetSprite) {
        sprites.add(sprite);
    }

    public function set_inPlay(inPlay : Bool) {
        this.inPlay = inPlay;
        for(sprite in sprites){
            if(inPlay) {
                sprite.disableMouseDrag(); 
                sprite.mouseDragCallback(false);
            } else {
                if(sprite.canDrag) sprite.enableMouseDrag();
                sprite.mouseDragCallback(true);
            }
        }
        return inPlay;
    }

    override public function update(elapsed : Float) {
        super.update(elapsed);
        for(sprite in sprites) {
            if(sprite.powered && !sprite.powerSource) sprite.powered = false;
        }
        for(sprite in sprites) {
            sprites.update(elapsed);
        }
    }

    private function loadSpritesFromLayer(layer : TiledLayer) {
        if(Std.is(layer, TiledTileLayer)) {
            var layer = cast(layer, TiledTileLayer);
            var flipObject : Array<{var x : Int; var y : Int;}> = try Json.parse(layer.properties.get("Flip")) catch(e : Any) null;
            var tileNumber = 0;
            for(tile in layer.tileArray) {
                var tileX = tileNumber%layer.width;
                var tileY = Math.floor(tileNumber/layer.width);
                var doFlip = false;
                if(flipObject != null){
                    for(flip in flipObject) {
                        doFlip = flip.x == tileX && flip.y == tileY;
                        if(doFlip) break;
                    }
                }
                var tileCanMove = tileY > 7;
                switch(tile) {
                    case 0:
                    case 1:
                        sprites.add(new Light(tileX, tileY, this, tileCanMove));
                    case 2:
                        sprites.add(new PowerButton(tileX, tileY, this, false));
                    case 3:
                        sprites.add(new SolarPanel(tileX, tileY, this, tileCanMove));
                    case 4:
                        sprites.add(new Wall(tileX, tileY, this, tileCanMove));
                    case 5:
                        sprites.add(new Wire(tileX, tileY, this, tileCanMove, true));
                    case 6:
                        sprites.add(new Wire(tileX, tileY-1, this, tileCanMove, false));
                    case 7:
                        sprites.add(new PowerBox(tileX, tileY, this, tileCanMove));
                    case 8:
                        var ns = new Cannon(tileX, tileY, this, tileCanMove);
                        sprites.add(ns);
                        if(doFlip) ns.flip();
                    case 9:
                        var ns = new Pusher(tileX, tileY, this, tileCanMove);
                        sprites.add(ns);
                        if(doFlip) ns.flip();
                    case 10:
                        var ns = new Teapot(tileX, tileY, this, tileCanMove);
                        sprites.add(ns);
                        if(doFlip) ns.flip();
                    case 11:
                        sprites.add(new Burner(tileX, tileY, this, tileCanMove));
                    case 12:
                        sprites.add(new SmokeDetector(tileX, tileY, this, tileCanMove));
                    case 13:
                        sprites.add(new Battery(tileX, tileY, this, tileCanMove));
                    case 14:
                        sprites.add(new HeliGrabber(tileX, tileY, this, tileCanMove));
                    default:
                        trace('Unknown tile: $tile!');
                }
                tileNumber++;
            }
        }
    }

    public function loadMap(index : Int, clear = true) {
        if(clear) sprites.clear();
        var mapLoader = new TiledMap(maps[index]);
        loadSpritesFromLayer(mapLoader.getLayer("Wires"));
        loadSpritesFromLayer(mapLoader.getLayer("Wires2"));
        loadSpritesFromLayer(mapLoader.getLayer("Widgets"));
    }

    public function loadNextMap() {
        loadMap(mapIndex++);
    }

}