class_name DropMenuUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _level:Level
var _parent
var _canvas:CanvasLayer
var _itemactionui:ItemActionUI
var button:Button
var _pressed:bool

func _init(player:Player, level:Level, canvas:CanvasLayer, parent, pressed = false):
    _ui_scene = preload("res://Level/MenuUI/Item/DropMenuUI.tscn")
    _player = player
    _level = level
    _parent = parent
    _canvas = canvas
    _pressed = pressed
    _instance = _ui_scene.instantiate()
    _instance.base_container = self
    _canvas.add_child(_instance)
    _instance.hide()
    button = _instance.get_child(0).get_child(0).get_child(0).get_child(0)
    _itemactionui = ItemActionUI.new(_player, _canvas, self)

## メニューの内容を更新する
func update_menu(object):
    button.visible = true
    button.text = object.object_name
    
# positionに落ちている物があるか確認する
func check_cell(position:Vector2):
    var cell = _level.get_map_cell(position)
    return cell.droppedobject
        
## ウィンドウを開く
func open_ui():
    var object = check_cell(_player.position_onlevel)
    if object != null:
        update_menu(object)
        _parent.pass_focus()
        self.get_focus()
        if _pressed == true:
            _itemactionui.open_ui(object)
    else:
        # todo:足元には何もないみたいなメッセージ出したい
        _parent.close_ui()
        
## ウィンドウを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()
    
## ItemActionUIを開く
func open_itemactionui():
    var item = check_cell(_player.position_onlevel)
    if item != null:
        _itemactionui.open_ui(item)
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
