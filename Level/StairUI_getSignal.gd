extends Control
var baseContainer:StairUI

# インスタンス管理用クラスからだとシグナルが受信できないので、
# シグナル受信用にこれを作成
func _ready():
    pass


func _on_yes_pressed():
    baseContainer.press_yesbutton()
    pass # Replace with function body.


func _on_no_pressed():
    baseContainer.press_nobutton()
    pass # Replace with function body.
