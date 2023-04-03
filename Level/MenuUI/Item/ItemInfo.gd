class_name ItemInfo
## アイテムの説明を見るためのクラス

var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _parent

func _init(player:Player, canvas:CanvasLayer, parent):
    _ui_scene = preload("res://Level/MenuUI/Item/ItemInfo.tscn")
    _player = player
    _parent = parent
    _instance = _ui_scene.instantiate()
    _instance.base_container = self
    canvas.add_child(_instance)
    _instance.hide()
    
## ウィンドウを開く
func open_ui(item:Item):
    _instance.find_child("RichTextLabel").text = item.infotext
    _parent.pass_focus()
    self.get_focus()

## ウィンドウを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()

## 他のUIから操作を取得する
func get_focus():
    _instance.show()
    _instance.set_process(true)
    
## 他のUIに操作を譲る
func pass_focus():
    _instance.hide()
    _instance.set_process(false)
