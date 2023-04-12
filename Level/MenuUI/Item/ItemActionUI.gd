class_name ItemActionUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _parent
var _item:Item
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
func open_ui():
    # x座標はItemMenuの左端に触るぐらいを目標に調整した
    # todo:置く、投げる、使うができる状態か判定してできない操作のボタンを非アクティブにする
    _instance.position = Vector2(732, 0)
    _parent.pass_focus()
    self.get_focus()

## itemmenuからこのUIを開く(親のwindowを閉じない)
func open_ui_from_itemmenu(itemnum:int):
    # x座標はItemMenuの左端に触るぐらいを目標に調整した
    _instance.position = Vector2(732, _buttonsize * itemnum)
    _item = _player.inventory.get_item(itemnum)
    _instance.find_child("Button").text = _item.action_name
    _parent.pass_focus(true)
    self.get_focus()
    
## このuiを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()

## 固有操作のボタンを押した時の挙動
func press_use_button():
    self.return_focus_to_player()
    _item.use(_player)
    pass

# todo:置く、投げる、使うを押した時、ターンを消費させる
## 投げるボタンを押した時の挙動
func press_throw_button():
    self.return_focus_to_player()
    _item.throw(_player)
    pass
    
## 置くボタンを押した時の挙動
func press_put_button():
    self.return_focus_to_player()
    _item.put(_player)
    pass
    
## 説明ボタンを押した時の挙動
func press_info_button():
    _parent._instance.hide()
    _iteminfo.open_ui(_item)
    pass

## UI制御をplayerに戻す
func return_focus_to_player():
    self.close_ui()
    _parent.pass_focus()
    _player.get_focus()

## 他のUIから操作を取得する
func get_focus():
    _parent._instance.show()
    _instance.show()
    _instance.find_child("Button").grab_focus()
    _instance.set_process(true)

## 他のUIに操作を譲る
func pass_focus():
    _instance.hide()
    _instance.set_process(false)
