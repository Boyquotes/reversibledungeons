class_name ItemMenuUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _parent
var _canvas:CanvasLayer
var _itemactionui:ItemActionUI

func _init(player:Player, canvas:CanvasLayer, parent):
    _ui_scene = preload("res://Level/MenuUI/Item/ItemMenuUI.tscn")
    _player = player
    _parent = parent
    _canvas = canvas
    _instance = _ui_scene.instantiate()
    _instance.base_container = self
    _canvas.add_child(_instance)
    _instance.hide()
    _itemactionui = ItemActionUI.new(_player, _canvas, self)
    
## ウィンドウを開く
func open_ui():
    _parent.pass_focus()
    self.get_focus()
    
## ウィンドウを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()
    
## 指定されたアイテムに対するItemActionUIを開く
func open_itemactionui(itemnum:int):
    _itemactionui.open_ui_from_itemmenu(itemnum)
    pass

## 他のUIから操作を取得する
func get_focus():
    _instance.show()
    _instance.find_child("Button").grab_focus()
    for i in _instance.find_children("", "Button"):
            i.disabled = false
    _instance.set_process(true)

## 他のUIに操作を譲る
func pass_focus(keep:bool = false):
    if keep == false:
        _instance.hide()
    else:
        # print_debug("pass_focus")
        # todo:無効化してるボタンをクリックするとフォーカス移るの対策したい
        for i in _instance.find_children("", "Button"):
            i.disabled = true
    _instance.set_process(false)
