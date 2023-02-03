extends Node2D
class_name Level
@onready var level = $Level
@onready var tile_map = $Level/TileMap
@onready var Stair:Sprite2D = $Level/Stair
@onready var text:Label = $Camera2D/CanvasLayer/Label2
@onready var Camera:Camera2D = $Camera2D
@onready var GeneralWindow:GeneralWindow = $Camera2D/CanvasLayer/GeneralWindow
# 後々のことを考えるとwall=0の方が安牌な気がする
enum Tile {TileOrange ,TileBlue, Wall}
const tilesize:int = 16
var floornum:int
var player:Player
var enemy:Enemy
var life_manager:LifeManage
var turn_manager:TurnManage
var cell:Array
var _stair_ui:StairUI
var _goal_ui:GoalUI
const mapdata = [
        [
            [],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,2,2],
            [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,2,2]
        ],
        [
            [],
            [],
            [1,1,0,0,0,0,0,0,0,1],
            [1,1,0,0,0,0,0,0,0,0],
            [1,1,0,0,0,0,0,0,0,0],
            [1,1,0,0,0,0,0,0,0,0],
            [2,2,2,2,2,0,2,2,2,2],
            [2,2,2,2,2,0,0,0,2,2]
        ]
    ]

func _init():
    floornum = 0

func _ready():
    # randomize() 現時点では未使用だが、ランダム生成する時には要るかも
    life_manager = LifeManage.new()
    player = Player.new(self, $Camera2D/CanvasLayer)
    level.add_child(player)
    enemy = Enemy.new(self,Vector2(3,5))
    level.add_child(enemy)
    life_manager.append(player)
    life_manager.append(enemy)
    _stair_ui = StairUI.new(player, self, $Camera2D/CanvasLayer)
    _goal_ui = GoalUI.new(player, self, $Camera2D/CanvasLayer)
    turn_manager = TurnManage.new(life_manager, $Camera2D/CanvasLayer/Label4)
    level.add_child(turn_manager)
    Camera.level = self
    Camera.player = player
    new_floor()
    
func new_floor():
    buildLevelFromData(Vector2i(30,20), mapdata[floornum])
    player.newfloor_warp(Vector2(5,5))
    # todo:初期位置指定方法変更
    # enemy.newfloor_warp(Vector2(3,5))
    floornum += 1
    pass

func _process(_delta):
    if Stair.position == (player.position):
        text.text = "(階段)({0},{1})".format([player.position_onlevel.x, player.position_onlevel.y])
    else:
        text.text = "({0})({1},{2})".format([cell[player.position_onlevel.x][player.position_onlevel.y], player.position_onlevel.x, player.position_onlevel.y])

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
    tile_map.set_cells_terrain_connect(0, bluetile, 0, Tile.TileBlue, false)
    tile_map.set_cells_terrain_connect(0, whitetile, 0, Tile.TileOrange, false)
    tile_map.set_cells_terrain_connect(0, wall, 0, Tile.Wall, false)
    Stair.position = Vector2(7,7) * tilesize

func get_map_cell(point:Vector2):
    var tilepos:Vector2 = point * tilesize
    var result = {}
    result["unit"] = null
    for e in life_manager.get_alive_unit():
        if e.position_onlevel == point:
            result["unit"] = e
            break
    if point.x >= cell.size() || point.y >= cell[point.x].size():
        result["tile"] = Tile.Wall
    else:
        result["tile"] = cell[point.x][point.y]
    if Stair.position == tilepos:
        result["stair"] = true
    else:
        result["stair"] = false
    return result
    
func get_position_diff_from_player(point:Vector2):
    GeneralWindow.show_message("ターン数:{1}, 距離：{0}".format([player.position_onlevel - point, turn_manager.turn]))
    return player.position_onlevel - point
    pass

func open_stair_ui():
    # 読み込み方めんどくさすぎる気がする…
    if floornum >= mapdata.size():
        _goal_ui.open_ui()
    else:
        _stair_ui.open_ui()
    pass
