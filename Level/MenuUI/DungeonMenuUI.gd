class_name DungeonMenuUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _level:Level
var _canvas:CanvasLayer
var _itemui:ItemMenuUI
var _dropui:DropMenuUI
func _init(player:Player, level:Level, canvas:CanvasLayer):
    _ui_scene = preload("res://Level/MenuUI/DungeonMenuUI.tscn")
    _player = player
    _canvas = canvas
    _level = level
    _instance = _ui_scene.instantiate()
    _instance.base_container = self
    canvas.add_child(_instance)
    _instance.hide()
    _itemui = ItemMenuUI.new(_player, _canvas, self)
    _dropui = DropMenuUI.new(_player, _level, _canvas, self, true)

## ウィンドウを開く    
func open_ui():
    _player.pass_focus()
    self.get_focus()

## ウィンドウを閉じる
func close_ui():
    self.pass_focus()
    _player.get_focus()

## 他のUIから操作を取得する
func get_focus():
    _instance.show()
    _instance.find_child("Item").grab_focus()
    _instance.set_process(true)
    
## 他のUIに操作を譲る
func pass_focus():
    _instance.hide()
    _instance.set_process(false)

## アイテムのボタンを押した時の処理
## アイテムメニューを開いてフォーカスを渡す 
func press_item_button():
    _itemui.open_ui()
    pass

func press_foot_button():
    _dropui.open_ui()
    pass
