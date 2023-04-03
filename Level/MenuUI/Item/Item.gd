class_name Item
# Called when the node enters the scene tree for the first time.
var action_name:String = "使う"
var _player:Player
var _window:GeneralWindow
var infotext = "説明表示テスト用"

## 動作に必要なクラスを取得する
func _init(player:Player,window:GeneralWindow):
    _player = player
    _window = window

## アイテムに対する固有の動作
func use():
    _window.show_message("〇〇を使った！")

## アイテムを投げる
func throw():
    _window.show_message("〇〇を投げた！")
    # todo:アイテムを投げる動作
    pass

## アイテムを投げて当たった時の動作
func clash(unit:Unit):
    # todo:投げて当たった時の動作
    unit.damage()
    pass

## アイテムを置く
func put():
    _window.show_message("〇〇を置いた")
    # todo:アイテムを置く動作
    pass
