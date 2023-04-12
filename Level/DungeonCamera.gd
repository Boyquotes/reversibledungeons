extends Camera2D
var level:Level
var player:Player
var viewsize:Vector2 
# Called when the node enters the scene tree for the first time.
func _ready():
    viewsize = get_window().size
    # print_debug(viewsize)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if level == null: return
    if player == null: return
    # よくわからないけど、なぜか中心取れてる
    var center = player.position * level.levelnode.scale - (viewsize / 2)
    # playerの中心座標のズレを補正
    # todo:AnimatedSprite2Dから真ん中を取得して補正に使いたい
    center.x += 10 * level.levelnode.scale.x
    # マップ端より先をカメラに入れないために、カメラ位置に上限、下限を設定しておく
    # todo:これの480,440ってどこに依存してる？
    self.offset = Vector2(clamp(center.x,0,480), clamp(center.y,0,440))
