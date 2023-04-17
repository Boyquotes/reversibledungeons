extends StairUI
class_name GoalUI
func _init(level:Level, canvas:CanvasLayer):
    _ui_scene = preload("res://LevelObject/Stair/GoalUI.tscn")
    _level = level
    _instance = _ui_scene.instantiate()
    _instance.baseContainer = self
    canvas.add_child(_instance)
    _instance.hide()

func press_yesbutton():
    close_ui()
    # ステージクリア
    _level.get_tree().change_scene_to_file("res://Title/Title.tscn")
    pass
