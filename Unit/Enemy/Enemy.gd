extends Unit
class_name Enemy
## 敵データの基本クラス
##
## 敵のHP、状態、位置を保持するためのクラス

## 初期化処理[br]
## animation_sceneとlevelを取得する
func _init(level:Level, position:Vector2) -> void:
    animation_scene = preload("res://Unit/Enemy/Enemy.tscn")
    _level = level
    self.position_onlevel = position
    self.position = position * _level.tilesize
    
## 自分のターンが来た時の行動[br]
## Playerと隣接していれば攻撃、していなければ接近する
func action():
    var diff = _level.get_position_diff_from_player(position_onlevel)
    if(abs(diff.x) <= 1 && abs(diff.y) <= 1):
        attack(diff.x,diff.y)
    else:
        var mx = clamp(diff.x, -1, 1)
        var my = clamp(diff.y, -1, 1)
        try_walk(mx, my)
    # メソッドチェーンをやめろ！！！！
    _level.turn_manager.action_end()
    pass

## destinationに移動可能かどうか_levelに問い合わせる
func can_move(destination:Vector2):
    var cell = _level.get_map_cell(destination)
    if(cell["tile"] == _level.Tile.Wall):
        return false
    #todo:ここに角抜け防止処理
    return true

## 横にdxマス、縦にdyマス先に対して移動を試みる
func try_walk(dx:int, dy:int) -> void:
    var x = position_onlevel.x + dx
    var y = position_onlevel.y + dy
    animation_change(dx,dy)
    if can_move(Vector2(x, y)) == true:
        update_position(Vector2(x, y))

## position_onlevelからdx,dyマス先に敵がいたら攻撃する
func attack(dx,dy):
    animation_change(dx, dy)
    var x = position_onlevel.x + dx
    var y = position_onlevel.y + dy
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell["unit"].tween != null):
        print_debug(cell["unit"].tween.is_running())
        if(cell["unit"].tween.is_running() == true):
            await cell["unit"].tween.finished
        await get_tree().create_timer(0.2).timeout
        cell["unit"].damage()

