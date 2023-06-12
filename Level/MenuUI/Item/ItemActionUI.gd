class_name ItemActionUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _parent
var _iteminfo:ItemInfo
const _buttonsize = 36 # ボタンの縦幅

func _init(player:Player, canvas:CanvasLayer, parent):
    _ui_scene = preload("res://Level/MenuUI/Item/ItemActionUI.tscn")
    _player = player
    _parent = parent
    _instance = _ui_scene.instantiate()
    _instance.base_container = self
    canvas.add_child(_instance)
    _instance.hide()
    _iteminfo = ItemInfo.new(_player, canvas, self)
    
## UIを開く(汎用)
## object:DroppedObject,InventoryItem
func open_ui(object):
    # x座標はItemMenuの左端に触るぐらいを目標に調整した
    _instance.position = Vector2(732, 0)
    self.update_button(object)

## itemmenuからこのUIを開く(親のwindowを閉じない)
func open_ui_from_itemmenu(itemnum:int):
    # x座標はItemMenuの左端に触るぐらいを目標に調整した
    # hack:この指定方法だと他解像度対応の時にズレそう…
    # todo:UIの下端が画面外に出ないよう調整
    _instance.position = Vector2(732, _buttonsize * itemnum)
    var item = _player.inventory.get_item(itemnum)
    self.update_button(item)
    
## このuiを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()
    
## 説明ボタンを押した時の挙動
func press_info_button(object):
    _parent._instance.hide()
    ## todo:説明表示機能修正
    _iteminfo.open_ui(object)

## UI制御をplayerに戻す
func return_focus_to_player():
    self.close_ui()
    _parent.pass_focus()
    _player.get_focus()

## 他のUIから操作を取得する
func get_focus():
    _parent._instance.show()
    _instance.show()
    var node = _instance.find_child("VBoxContainer").get_children()[0]
    node.grab_focus()
    _instance.set_process(true)

## 他のUIに操作を譲る
func pass_focus():
    _instance.hide()
    _instance.set_process(false)
    
## 行動用のボタンを生成する
func generate_button(action_name:String,action:Callable) -> Button:
    var result:Button = Button.new()
    result.text = action_name
    result.pressed.connect(specific_action.bind(action))
    return result
    
## 行動用のボタンを生成する(押した後、playerに制御を渡さない)
func generate_button_not_return(action_name:String,action:Callable) -> Button:
    var result:Button = Button.new()
    result.text = action_name
    result.pressed.connect(action)
    return result
    
func specific_action(action:Callable):
    self.return_focus_to_player()
    action.call()
    
## GUI内のボタンを更新する[br]
## object:DroppedObject,InventoryItem
func update_button(object):
    self.button_clear()
    ## todo:buttonはコンストラクタでfindして変数に持っておいたほうがいいかも
    var container:VBoxContainer = _instance.find_child("VBoxContainer")
    var actionbuton = object.get_gui_button(_player)
    for button in actionbuton:
        # todo:button[2]がfalseだったらボタンをdisableにする
        var new_button = generate_button(button[0], button[1])
        if button[2] == false:
            new_button.disabled = true
        container.add_child(new_button)
    container.add_child(generate_button_not_return("説明", press_info_button.bind(object)))
    container.add_child(generate_button_not_return("戻る", close_ui))
    _parent.pass_focus()
    self.get_focus()
    
## このGUIのボタンを全て削除する
func button_clear():
    var container:VBoxContainer = _instance.find_child("VBoxContainer")
    for button in container.get_children():
        container.remove_child(button)
        button.queue_free()
