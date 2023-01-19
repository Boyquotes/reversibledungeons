extends Camera2D
var level:Level
var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if level == null: return
    if player == null: return
    # よくわからないけど、なぜか中心取れてる
    var center = player.position * level.scale * 3 - Vector2(450,260)
    # マップ端より先をカメラに入れないために、カメラ位置に上限、下限を設定しておく
    self.offset = Vector2(clamp(center.x,0,480), clamp(center.y,0,440))
