class_name Item
# Called when the node enters the scene tree for the first time.
var action_name:String = "使う"
var _window:GeneralWindow
var _level:Level
var name:String = "テスト用アイテム"
var infotext = "説明表示テスト用"

## 動作に必要なクラスを取得する
func _init(window:GeneralWindow, level:Level):
    _window = window
    _level = level

## アイテムに対する固有の動作
func use(player:Player):
    ## ここに使った時の挙動入れる
    player.inventory.delete(self)
    _window.show_message("{0}を使った！".format([self.name]))

## アイテムを投げる
func throw(player:Player):
    player.inventory.delete(self)
    DroppedItem.new(_level, player.position_onlevel, player.get_animation())
    
    _window.show_message("{0}を投げた！".format([self.name]))
    pass

## アイテムを投げて当たった時の動作
func clash(unit:Unit):
    # todo:投げて当たった時の動作
    unit.damage()
    pass

## アイテムを置く
func put(player:Player):
    DroppedItem.new(_level, player.position_onlevel)
    player.inventory.delete(self)
    _window.show_message("{0}を置いた".format([self.name]))
    # todo:アイテムを置く動作
    pass
