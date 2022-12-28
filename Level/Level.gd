extends Node2D
class_name Level
@onready var tile_map = $TileMap
@onready var Stair:Sprite2D = $Stair
@onready var text:Label = $Label2
# 後々のことを考えるとwall=0の方が安牌な気がする
enum Tile {TileOrange ,TileBlue, Wall}
const tilesize:int = 16
var floornum:int
var player:Player
var cell:Array
const mapdata = [
        [
            [],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,1,1,0],
            [2,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [1]
        ],
        [
            [],
            [],
            [1,1,0,0,0,0,0,0,0,1],
            [1,1,0,0,0,0,0,0,0,0],
            [1,1,0,0,0,0,0,0,0,0],
            [1,1,0,0,0,0,0,0,0,0]
        ]
    ]
func _init():
    floornum = 0

func _ready():
    randomize()
    buildLevelFromData(Vector2i(15,10), mapdata[0])
    player = Player.new(tilesize, Vector2(5,5), self)
    add_child(player)
    
func _process(_delta):
    # Playerのサイズが縦に長いので、1マス分判定を下げている
    if Stair.position == (player.position):
        text.text = "(階段)({0},{1})".format([player.player_tile.x, player.player_tile.y])
    else:
        text.text = "({0})({1},{2})".format([cell[player.player_tile.x][player.player_tile.y], player.player_tile.x, player.player_tile.y])

# mapdataから地形を生成する
# mapdata:生成する地形のデータ(int型2次元配列)
func buildLevelFromData(size:Vector2i, mapdata:Array):
    tile_map.clear()
    
    var bluetile:Array = []
    var whitetile:Array = []
    var wall:Array = []
    cell = []
    
    # cellの初期化
    for x in range(size.x):
        cell.append([])
        for y in range(size.y):
            cell[x].append(Tile.Wall)
            
    for y in range(size.y):
        for x in range(size.x):
            if(y < mapdata.size() and x < mapdata[y].size()):
                if mapdata[y][x] == 1:
                    bluetile.append(Vector2i(x, y))
                    cell[x][y]=Tile.TileBlue
                elif mapdata[y][x] == 0:
                    whitetile.append(Vector2i(x, y))
                    cell[x][y]=Tile.TileOrange
                else:
                    wall.append(Vector2i(x, y))
                    cell[x][y]=Tile.Wall
            else:
                wall.append(Vector2i(x, y))
                cell[x][y]=Tile.Wall
            
    #tile_map.update_bitmask_region()
    tile_map.set_cells_terrain_connect(0, bluetile, 0, Tile.TileBlue)
    tile_map.set_cells_terrain_connect(0, whitetile, 0, Tile.TileOrange)
    tile_map.set_cells_terrain_connect(0, wall, 0, Tile.Wall)
    Stair.position = Vector2(7,7) * tilesize

func get_map_cell(point:Vector2):
    var result = {}
    if point.x >= cell.size() || point.y >= cell[point.x].size():
        result["tile"] = Tile.Wall
    else:
        result["tile"] = cell[point.x][point.y]
    if Stair.position == (player.position):
        result["stair"] = true
    else:
        result["stair"] = false
    return result
