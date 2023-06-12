class_name DroppedTrap
extends DroppedObject

var _trap:Trap

func _init(level:Level, position:Vector2, trap:Trap):
    sprite = Sprite2D.new()
    var texture = load(trap.imagepass)
    sprite.set_texture(texture)
    sprite.centered = false
    self.add_child(sprite)
    _level = level
    trap.delete = self.delete
    _trap = trap
    object_name = _trap.object_name
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    _level.pop_item(self, position_onlevel)

## 罠を踏んだ時の挙動
func stepon(_stepper):
    ## メッセージ処理はTrapに置いておきたい
    if _stepper is Unit:
        _level.GeneralWindow.show_message("罠を踏んだ！")
    elif _stepper is ThrowingItem:
        _level.GeneralWindow.show_message("アイテムが罠を踏んだ！")
    _trap.stepon(_stepper)

## GUIに渡すために固有操作のボタンを返す
func get_gui_button(user:Unit):
    var result:Array = []
    result.append([_trap.action_name,self.stepon.bind(user),true])
    return result
    
# 説明を取得する
func get_information():
    return _trap.infotext
