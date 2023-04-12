extends Control
var baseContainer:StairUI

# インスタンス管理用クラスからだとシグナルが受信できないので、
# シグナル受信用にこのクラスを作成
func _ready():
    assert(baseContainer)
    pass

func _process(_delta):
    if Input.is_action_just_released("ui_cancel"):
        if self.visible == true:
            baseContainer.press_nobutton()

func _on_yes_pressed():
    baseContainer.press_yesbutton()
    pass # Replace with function body.


func _on_no_pressed():
    baseContainer.press_nobutton()
    pass # Replace with function body.
