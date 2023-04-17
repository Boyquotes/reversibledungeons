class_name StairUI
var _ui_scene:PackedScene
var _instance:Control
var _parent
var _level:Level
func _init(level:Level, canvas:CanvasLayer):
    _ui_scene = preload("res://LevelObject/Stair/StairUI.tscn")
    _level = level
    _instance = _ui_scene.instantiate()
    _instance.baseContainer = self
    canvas.add_child(_instance)
    _instance.hide()
    
## ウィンドウを開く    
func open_ui(parent):
    _parent = parent
    _parent.pass_focus()
    self.get_focus()

## ウィンドウを閉じる
func close_ui():
    self.pass_focus()
    _parent.get_focus()

## 他のUIから操作を取得する
func get_focus():
    _instance.show()
    _instance.find_child("Yes").grab_focus()
    _instance.set_process(true)
    
## 他のUIに操作を譲る
func pass_focus():
    _instance.hide()
    _instance.set_process(false)
    
func press_yesbutton():
    close_ui()
    _level.new_floor()
    pass
    
func press_nobutton():
    close_ui()
    pass 
