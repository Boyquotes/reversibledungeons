extends Control
class_name GeneralWindow
@onready var window:RichTextLabel = $MarginContainer/PanelContainer/RichTextLabel
var timer:SceneTreeTimer
var tween:Tween
var _propetytween:PropertyTweener

func _init():
    self.hide()
    
func _ready():
    pass
    
func _process(_delta):
    if timer != null:
        # print_debug(timer.time_left)
        if timer.time_left < 0:
            self.hide()
            self.set_process(false)
    
func show_message(text:String):
    window.add_text(text)
    window.newline()
    self.show()
    var bar:VScrollBar = window.get_v_scroll_bar()
    # なぜかこの計算処理を入れるとTweenで下までスクロールできる(バグ?)
    window.get_line_count()
    if(tween != null):
        tween.kill()
    tween = get_tree().create_tween()
    _propetytween = tween.tween_property(bar, "value", bar.max_value, 0.3)
    timer = get_tree().create_timer(2)
    self.set_process(true)
    pass


func _on_hidden():
    window.clear()
