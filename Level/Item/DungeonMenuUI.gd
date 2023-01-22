class_name DungeonMenuUI
var _ui_scene:PackedScene
var _instance:Control
var _player:Player
func _init(player:Player, canvas:CanvasLayer):
    _ui_scene = preload("res://Level/Item/DungeonMenuUI.tscn")
    _player = player
    _instance = _ui_scene.instantiate()
    _instance.baseContainer = self
    canvas.add_child(_instance)
    _instance.hide()
    
func open_ui():
    _player.isActive = false
    _instance.show()
    _instance.find_child("Item").grab_focus()
    _instance.set_process(true)
    
func close_ui():
    _instance.hide()
    _instance.set_process(false)
    _player.close_ui()
    
func press_button():
    close_ui()
    pass
