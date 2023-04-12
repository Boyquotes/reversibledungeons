class_name DroppedItem
extends Node2D

var sprite:Sprite2D
var _level:Level

## Level上にあるこのUnitの座標
var position_onlevel:Vector2

func _init(level:Level, position:Vector2, throw_direction:Vector2 = Vector2(0,0)):
    sprite = preload("res://Item/DroppedItem.tscn").instantiate()
    self.add_child(sprite)
    _level = level
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    # hack:投げる処理がコンストラクタに入ってるの気持ち悪くない？
    if throw_direction == Vector2(0,0):
        _level.pop_item(self, position_onlevel)
    else:
        throw(throw_direction)
    
func pick(player:Player):
    var item = Item.new(_level.GeneralWindow, _level)
    return item
    
func throw(direction:Vector2):
    if direction.x > 0:
        direction.x = 1
    elif direction.x < 0:
        direction.x = -1
    if direction.y > 0:
        direction.y = 1
    elif direction.y < 0:
        direction.y = -1
    # todo:rangeの内容は射程 アイテム内で指定可能にしてもいいかも?
    for i in range(10):
        var destination = self.position_onlevel + direction
        # todo:行き先が移動可能か判定する ダメそうならその場に落とす
        if can_move(destination):
            self.position_onlevel = destination
            var tween = get_tree().create_tween()
            var _propetytween:PropertyTweener = tween.tween_property(self, "position", position_onlevel * _level.tilesize, 0.05)
            tween.play()
            await tween.finished
            if after_move():
                return
        else:
            drop(self.position_onlevel)
            return
    drop(self.position_onlevel)

## destinationに移動可能かどうか_levelに問い合わせる
func can_move(destination:Vector2):
    var cell = _level.get_map_cell(destination)
    if cell.tiletype == _level.Tile.Wall:
        return false
    #todo:ここに角抜け防止処理
    return true

# 位置更新後に呼び出す処理
func after_move():
    var cell = _level.get_map_cell(position_onlevel)
    if cell.unit != null:
        self.clash(cell.unit)

func drop(destination:Vector2):
    # todo:cellのitemが空ならそこに落とし、空でないなら隣接する空のマスを探して落とす機能を入れる
    _level.pop_item(self, position_onlevel)
    print_debug(destination)
    
func clash(unit:Unit):
    # todo:命中しなかったor敵にぶつかっても壊れるタイプのアイテムじゃなかった場合、Drop()
    var item = Item.new(_level.GeneralWindow, _level)
    item.clash(unit)
    queue_free()

# 画面とマップデータからこのアイテムを消す
func delete():
    _level.delete_item(self, position_onlevel)
    queue_free()
