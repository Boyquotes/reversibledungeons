extends AnimatedSprite
class_name Player


var player_tile

## todo:tilesizeはlevelにだけ持たせたい
var tilesize = 16

# Called when the node enters the scene tree for the first time.
func _ready():
    player_tile = Vector2(5, 5)
    position = player_tile * tilesize


func _process(delta):
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
    ## todo:このへんにマップの地形属性取得して云々したり壁に当たったら進めない処理書く
    player_tile = Vector2(x, y)
    update()

func update():
    set_process(false)
    $Tween.interpolate_property(self, "position", null, player_tile * tilesize, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween,"tween_completed")
    set_process(true)
    #position = player_tile * tilesize
    
func animation_change(x,y):
    if y == -1:
        if x == -1:
            play("Up-Left")
        elif x == 1:
            play("Up-Right")
        else:
            play("Up")
    elif y == 1:
        if x == -1:
            play("Down-Left")
        elif x == 1:
            play("Down-Right")
        else:
            play("Down")
    else:
        if x == -1:
            play("Left")
        elif x == 1:
            play("Right")
        
            

