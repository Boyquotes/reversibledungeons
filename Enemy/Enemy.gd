extends Node2D
class_name Enemy

@onready var animation_scene = preload("res://Enemy/Enemy.tscn")
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

func _init(DefaultTilesize:int, level:Level):
    tilesize = DefaultTilesize
    _level = level
    self.scale = level.scale

func _ready():
    animation = animation_scene.instantiate()
    add_child(animation)

func try_move(dx, dy):
    var x = player_tile.x + dx
    var y = player_tile.y + dy
    animation_change(dx,dy)
    if can_move(x,y) == true:
        player_tile = Vector2(x, y)
        update()

func update():
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", player_tile * tilesize, 0.3)
    tween.play()
    await tween.finished
    
func animation_change(x,y):
    var playanim = AnimationType[x+1][y+1]
    if playanim != "None":
        animation.play(playanim)
        
func can_move(x:int,y:int):
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell["tile"] == _level.Tile.Wall):
        return false
    #todo:ここに角抜け防止処理
    if(cell["stair"] == true):
        #todo:本来はupdate()の後で呼ばれるべき
        _level.open_StairUI()
    return true

func newfloor_warp(position:Vector2):
    self.player_tile = position
    self.position = position * tilesize
    pass
    
func attack(dx,dy):
    animation_change(dx, dy)
    var x = player_tile.x + dx
    var y = player_tile.y + dy
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell["unit"] != null):
        cell["unit"].damage()

func damage():
    # メソッドチェーンをやめろ！！！！
    # ここsignalでもいい気がする
    _level.life_manager.death(self)
    queue_free()
    
func action():
    var diff = _level.get_position_diff_from_player(player_tile)
    if(abs(diff.x) <= 1 && abs(diff.y) <= 1):
        attack(diff.x,diff.y)
    else:
        var mx = clamp(diff.x, -1, 1)
        var my = clamp(diff.y, -1, 1)
        var move = Vector2(mx,my)
        try_move(move.x, move.y)
    # メソッドチェーンをやめろ！！！！
    _level.turn_manager.action_end()
    pass
        
            

