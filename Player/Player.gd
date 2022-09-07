extends AnimatedSprite
class_name Player


var player_tile

## todo:tilesizeはlevelにだけ持たせたい
var tilesize = 16

# Called when the node enters the scene tree for the first time.
func _ready():
    player_tile = Vector2(5, 5)
    position = player_tile * tilesize


func _input(event):
    var _x = 0
    var _y = 0
    if event.is_pressed() == false:
        return
    if event.is_action("ui_left"):
        _x -= 1
    elif event.is_action("ui_right"):
        _x += 1
    elif event.is_action("ui_up"):
        _y -= 1
    elif event.is_action("ui_down"):
        _y += 1

    if _x != 0 or _y != 0:
        try_move(_x, _y)
    
    ## fix:たぶんここに書いちゃダメだと思う
    update()

func try_move(dx, dy):
    var x = player_tile.x + dx
    var y = player_tile.y + dy

    ## todo:マップのサイズ取得してマップの外に出れないようにする
    # if x >= 0 && x < level_size.x && y >= 0 && y < level_size.y:
    # tile_type = map[x][y]    
    
    ## todo:このへんにマップの地形属性取得して云々したり壁に当たったら進めない処理書く
    player_tile = Vector2(x, y)

func update():
    position = player_tile * tilesize

