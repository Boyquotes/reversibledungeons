class_name ItemMenuUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _parent
var _canvas:CanvasLayer
var _itemactionui:ItemActionUI
var buttons:Array[Button] = []

func _init(player:Player, canvas:CanvasLayer, parent):
    _ui_scene = preload("res://Level/MenuUI/Item/ItemMenuUI.tscn")
    _player = player
    _parent = parent
    _canvas = canvas
    _instance = _ui_scene.instantiate()
    buttons.append_array(_instance.get_child(0).get_child(0).get_child(0).get_children())
    _instance.base_container = self
    _canvas.add_child(_instance)
    _instance.hide()
    _itemactionui = ItemActionUI.new(_player, _canvas, self)

## メニューの内容を更新する
func update_menu(page:int):
    var items:Array[Item] = _player.inventory.get_list()
    # todo:1ページ目以外にも対応
    for i in range(buttons.size()):
        if i >= items.size():
            buttons[i].visible = false
        else:
            buttons[i].text = items[i].name
            buttons[i].visible = true

## ウィンドウを開く
func open_ui():
    update_menu(0)
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
