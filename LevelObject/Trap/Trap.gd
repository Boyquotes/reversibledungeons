class_name Trap
extends DroppedObject

func _init(level:Level, position:Vector2):
    sprite = Sprite2D.new()
    var texture = load("res://LevelObject/Trap/TrapSample.png")
    sprite.set_texture(texture)
    sprite.centered = false
    self.add_child(sprite)
    _level = level
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    _level.pop_item(self, position_onlevel)

func stepon(_stepper:Unit):
    _level.GeneralWindow.show_message("罠を踏んだ！")
 
# 画面とマップデータからこのアイテムを消す
func delete():
    _level.delete_item(self, position_onlevel)
    queue_free()
