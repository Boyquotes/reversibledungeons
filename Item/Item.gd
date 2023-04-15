class_name Item
# Called when the node enters the scene tree for the first time.
var action_name:String = "使う"
var _window:GeneralWindow
var _level:Level
var _player:Player
var name:String = "テスト用アイテム"
var infotext = "説明表示テスト用"

## 動作に必要なクラスを取得する
## playerというよりは所有者な気もする 将来的にunitに変更?
func _init(window:GeneralWindow, level:Level, player:Player):
    _window = window
    _level = level
    _player = player

## アイテムに対する固有の動作
func use():
    ## ここに使った時の挙動入れる
    _player.inventory.delete(self)
    _window.show_message("{0}を使った！".format([self.name]))

## アイテムを投げる
func throw():
    _player.inventory.delete(self)
    ThrowingItem.new(self, _level, _player, _player.get_animation())
    _window.show_message("{0}を投げた！".format([self.name]))
    pass

## アイテムを投げて当たった時の動作
func clash(unit:Unit):
    # todo:投げて当たった時の動作
    var damage = DamageObject.new(_player)
    unit.damage(damage)
    pass

## アイテムを置く
func put():
    DroppedItem.new(self, _level, _player.position_onlevel)
    _player.inventory.delete(self)
    _window.show_message("{0}を置いた".format([self.name]))
    # todo:アイテムを置く動作
    pass
