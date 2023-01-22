class_name StairUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
var _level:Level
func _init(player:Player, level:Level, canvas:CanvasLayer):
    _ui_scene = preload("res://Level/Stair/StairUI.tscn")
    _player = player
    _level = level
    _instance = _ui_scene.instantiate()
    _instance.baseContainer = self
    canvas.add_child(_instance)
    _instance.hide()
    
func open_ui():
    _player.isActive = false
    _instance.show()
    _instance.set_process(true)
    _instance.find_child("Yes").grab_focus()
    
func close_ui():
    _instance.hide()
    _instance.set_process(false)
    _player.close_ui()
    
func press_yesbutton():
    close_ui()
    _level.new_floor()
    pass
    
func press_nobutton():
    close_ui()
    pass 
