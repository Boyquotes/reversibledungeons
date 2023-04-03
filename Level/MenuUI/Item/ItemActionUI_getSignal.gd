extends Control
var base_container:ItemActionUI

# インスタンス管理用クラスからだとシグナルが受信できないので、
# シグナル受信用にこのクラスを作成
func _ready():
    assert(base_container)
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if Input.is_action_just_released("ui_cancel"):
        if self.visible == true:
            base_container.close_ui()


func _on_button_pressed():
    base_container.press_use_button()
    pass # Replace with function body.


func _on_button_2_pressed():
    base_container.press_throw_button()
    pass # Replace with function body.


func _on_button_3_pressed():
    base_container.press_put_button()
    pass # Replace with function body.


func _on_button_4_pressed():
    base_container.press_info_button()
    pass # Replace with function body.
