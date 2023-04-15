class_name DroppedItem
extends Node2D

var _item:Item
var sprite:Sprite2D
var _level:Level

## Level上にあるこのItemの座標
var position_onlevel:Vector2

## todo:itemはどのアイテムか判別さえできればOK 将来的にはitemIDとかで区別
func _init(item:Item, level:Level, position:Vector2):
    sprite = preload("res://Item/DroppedItem.tscn").instantiate()
    self.add_child(sprite)
    _item = item
    _level = level
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    _level.pop_item(self, position_onlevel)

func pick():
    return _item
 
# 画面とマップデータからこのアイテムを消す
func delete():
    _level.delete_item(self, position_onlevel)
    queue_free()
