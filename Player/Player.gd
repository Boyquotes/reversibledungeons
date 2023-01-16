extends Node2D
class_name Player

@onready var animation_scene = preload("res://Player/Player.tscn")
var animation:AnimatedSprite2D
var player_tile:Vector2
var tilesize:int
var tween:Tween
var _level:Level
var myturn:bool
var isActive:bool = true :set = _set_active
const AnimationType:Array = [
    ["Up-Left","Left","Down-Left"],
    ["Up","None","Down"],
    ["Up-Right","Right","Down-Right"],
    ]

func _init(DefaultTilesize:int, level:Level):
    tilesize = DefaultTilesize
    _level = level
    self.scale = level.scale

func _ready():
    animation = animation_scene.instantiate()
    add_child(animation)

func _set_active(flag:bool):
    isActive = flag
    _switch_process(isActive)

func _switch_process(run:bool):
    if(run == false):
        set_process(false)
    else:
        if(isActive == true):
            set_process(true)

func _process(_delta):
    if (myturn == false):
        return
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
    if Input.is_action_pressed("ui_accept"):
        attack()
        pass
        
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
    animation_change(dx,dy)
    if can_move(x,y) == true:
        player_tile = Vector2(x, y)
        update()
        # todo:仮設置 将来的に外す
        action_end()

func update():
    _switch_process(false)
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", player_tile * tilesize, 0.3)
    tween.play()
    await tween.finished
    _switch_process(true)
    
func animation_change(x,y):
    var playanim = AnimationType[x+1][y+1]
    if playanim != "None":
        animation.play(playanim)
        
func can_move(x:int,y:int):
    var cell = _level.get_map_cell(Vector2(x,y))
    if cell["tile"] == _level.Tile.Wall:
        return false
    if cell["unit"] != null:
        return false
    #todo:ここに角抜け防止処理
    if(cell["stair"] == true):
        #todo:本来はupdate()の後で呼ばれるべき
        _level.open_stair_ui()
    return true

func newfloor_warp(position:Vector2):
    self.player_tile = position
    self.position = position * tilesize
    pass
        
func attack():
    var direction:Vector2 = get_animation()
    var x = player_tile.x + direction.x
    var y = player_tile.y + direction.y
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell["unit"] != null):
        cell["unit"].Damage()
    _switch_process(false)
    # todo:ここから下仮設置 将来的に外す
    # 暴発対策にupdate()もどきを入れておいた
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", player_tile * tilesize, 0.2)
    tween.play()
    await tween.finished
    _switch_process(true)
    action_end()
    
func get_animation():
    var name = animation.animation
    for x in range(AnimationType.size()):
        var y = AnimationType[x].find(name)
        if y != -1:
            return Vector2(x-1,y-1)
    return Vector2(0,0)

func damage():
    # メソッドチェーンをやめろ！！！！
    _level.life_manager.death(self)
    queue_free()
    _level.get_tree().change_scene_to_file("res://Title/Title.tscn")

func action():
    myturn = true
    
func action_end():
    print_debug("Player.Action_end")
    myturn = false
    # メソッドチェーンをやめろ！！！！
    _level.turn_manager.action_end()
    pass
