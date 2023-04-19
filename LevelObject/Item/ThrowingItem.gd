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
    sprite = preload("res://LevelObject/Item/DroppedItem.tscn").instantiate()
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
    if can_put(position_onlevel) == false:
        var cell = _level.get_map_cell(position_onlevel)
        if cell.droppedobject is Trap:
            cell.droppedobject.stepon_item(self)
    else:
        DroppedItem.new(_item, _level, position_onlevel)
        queue_free()
        return
    
    # 第一候補地に置けなかったので横のマスに置きたい
    # 第一候補地を中心に3×3の範囲で反時計回り→5×5の範囲で反時計回り
    var target = [Vector2(-1,-1),Vector2(0,-1),Vector2(1,-1),
    Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(-1,1),Vector2(-1,0),
    Vector2(-2,-2),Vector2(-1,-2),Vector2(0,-2),Vector2(1,-2),
    Vector2(2,-2),Vector2(2,-1),Vector2(2,0),Vector2(2,1),
    Vector2(2,2),Vector2(1,2),Vector2(0,2),Vector2(-1,2),
    Vector2(-2,2),Vector2(-2,1),Vector2(-2,0),Vector2(-2,-1)]
    
    for diff in target:
        var destination = position_onlevel + diff
        if can_put(destination) == true:
            var tween = get_tree().create_tween()
            var _propetytween:PropertyTweener = tween.tween_property(self, "position", destination * _level.tilesize, 0.05)
            tween.play()
            await tween.finished
            DroppedItem.new(_item, _level, destination)
            queue_free()
            return
            
    # 置けそうにないので消滅する
    _level.GeneralWindow.show_message("アイテムは消滅してしまった…")
    queue_free()
    return
    
func can_put(destination:Vector2):
    var cell = _level.get_map_cell(destination)
    if cell.tiletype == _level.Tile.Wall:
        return false
    if cell.droppedobject != null:
        return false
    return true

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
