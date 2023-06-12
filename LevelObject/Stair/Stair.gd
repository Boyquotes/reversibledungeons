extends DroppedObject
class_name Stair

var stair_ui:StairUI

func _init(level:Level, position:Vector2):
    sprite = Sprite2D.new()
    var texture = load("res://LevelObject/Stair/Stair.png")
    sprite.set_texture(texture)
    sprite.centered = false
    self.add_child(sprite)
    _level = level
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    _level.pop_item(self, position_onlevel)
    if level.floornum >= 1:
        stair_ui = GoalUI.new(level, level.ui_canvas)
    else:
        stair_ui = StairUI.new(level, level.ui_canvas)

func stepon(stepper:Unit):
    if stepper is Player:
        stair_ui.open_ui(stepper)
 
# 画面とマップデータからこのアイテムを消す
func delete():
    _level.delete_item(self, position_onlevel)
    queue_free()
