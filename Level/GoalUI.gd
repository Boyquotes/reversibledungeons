class_name GoalUI
const _ui_scene = preload("res://Level/GoalUI.tscn")
var _instance:Control
var _player:Player
var _level:Level
func _init(player:Player, level:Level, canvas:CanvasLayer):
    _player = player
    _level = level
    _instance = _ui_scene.instantiate()
    _instance.baseContainer = self
    canvas.add_child(_instance)
    _instance.hide()
    
func open_ui():
    _instance.show()
    _player.isActive = false
    _instance.find_child("Yes").grab_focus()
    
func close_ui():
    _instance.hide()
    _player.isActive = true
    
func press_yesbutton():
    close_ui()
    # ステージクリア
    _level.get_tree().change_scene_to_file("res://Title/Title.tscn")
    pass
    
func press_nobutton():
    close_ui()
    pass 
