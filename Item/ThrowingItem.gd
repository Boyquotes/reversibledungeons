class_name ThrowingItem
extends Node2D

var _item:Item
var sprite:Sprite2D
var _level:Level
var _thrower:Unit
## Level上にあるこのItemの座標
var position_onlevel:Vector2

## todo:itemはどのアイテムか判別さえできればOK 将来的にはitemIDとかで区別
func _init(item:Item, level:Level, thrower:Unit, throw_direction:Vector2 = Vector2(0,0)):
    sprite = preload("res://Item/DroppedItem.tscn").instantiate()
    self.add_child(sprite)
    _item = item
    _level = level
    _thrower = thrower
    self.position_onlevel = _thrower.position_onlevel
    self.position = self.position_onlevel * _level.tilesize
    _level.levelnode.add_child(self)
    assert(throw_direction != Vector2(0,0))
    throw(throw_direction)

func clash(unit:Unit):
    # todo:命中しなかったor敵にぶつかっても壊れるタイプのアイテムじゃなかった場合、Drop()
    var item = Item.new(_level.GeneralWindow, _level, _thrower)
    item.clash(unit)
    queue_free()
    
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
            drop()
            return
    drop()
    
func drop():
    # todo:cellのitemが空ならそこに落とし、空でないなら隣接する空のマスを探して落とす機能を入れる
    DroppedItem.new(_item, _level, position_onlevel)
    queue_free()
    
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
