extends Node2D
class_name Player

@onready var animation_scene = preload("res://Player/Player.tscn")
var animation:AnimatedSprite2D
var player_tile:Vector2
var tilesize:int
var tween:Tween
var _level:Level
const AnimationType:Array = [
    ["Up-Left","Left","Down-Left"],
    ["Up","None","Down"],
    ["Up-Right","Right","Down-Right"],
    ]

func _init(DefaultTilesize:int, StartPosition:Vector2, level:Level):
    tilesize = DefaultTilesize
    player_tile = StartPosition
    position = player_tile * tilesize
    _level = level

# Called when the node enters the scene tree for the first time.
func _ready():
    animation = animation_scene.instantiate()
    add_child(animation)

func _process(_delta):
    var _x = 0
    var _y = 0
    var diagonalonly : bool = false
    var changedirection : bool = false
    if Input.is_action_pressed("ui_left"):
        _x -= 1
    if Input.is_action_pressed("ui_right"):
        _x += 1
    if Input.is_action_pressed("ui_up"):
        _y -= 1
    if Input.is_action_pressed("ui_down"):
        _y += 1
    if Input.is_action_pressed("ui_diagonal_only"):
        diagonalonly = true
    if Input.is_action_pressed("ui_change_direction"):
        changedirection = true
        
    if diagonalonly == false and (_x != 0 or _y != 0):
        if changedirection == false:
            try_move(_x, _y)
        else:
            animation_change(_x,_y)
    elif diagonalonly == true and (_x != 0 and _y != 0):
        if changedirection == false:
            try_move(_x, _y)
        else:
            animation_change(_x,_y)

func try_move(dx, dy):
    var x = player_tile.x + dx
    var y = player_tile.y + dy
    ## todo:マップのサイズ取得してマップの外に出れないようにする
    # if x >= 0 && x < level_size.x && y >= 0 && y < level_size.y:
    # tile_type = map[x][y]    
    
    animation_change(dx,dy)
    if can_move(x,y) == true:
        player_tile = Vector2(x, y)
        update()

func update():
    set_process(false)
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", player_tile * tilesize, 0.3)
    tween.play()
    await tween.finished
    set_process(true)
    #position = player_tile * tilesize
    
func animation_change(x,y):
    var playanim = AnimationType[x+1][y+1]
    if playanim != "None":
        animation.play(playanim)
        
func can_move(x:int,y:int):
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell["tile"] != _level.Tile.Wall):
        return true
    else:
        return false
        
            

