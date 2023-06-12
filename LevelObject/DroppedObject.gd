class_name DroppedObject
extends Node2D

var sprite:Sprite2D
var _level:Level
var object_name:String

## Level上にあるこのItemの座標
var position_onlevel:Vector2

## 踏んだ時の挙動
func stepon(stepper):
    pass

## GUIに渡すために固有操作のボタンを返す
func get_gui_button(user:Unit):
    pass
    
# 画面とマップデータからこのアイテムを消す
func delete():
    _level.delete_item(self, position_onlevel)
    queue_free()
    
# 説明を取得する
func get_information():
    pass
