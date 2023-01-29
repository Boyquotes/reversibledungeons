extends Control
var baseContainer:DungeonMenuUI

# インスタンス管理用クラスからだとシグナルが受信できないので、
# シグナル受信用にこのクラスを作成
func _ready():
    assert(baseContainer)
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if Input.is_action_just_released("ui_cancel"):
        if self.visible == true:
            baseContainer.press_button()

func _on_item_pressed():
    baseContainer.press_button()
    pass # Replace with function body.

func _on_reserve_pressed():
    baseContainer.press_button()
    pass # Replace with function body.


func _on_foot_pressed():
    baseContainer.press_button()
    pass # Replace with function body.


func _on_other_pressed():
    baseContainer.press_button()
    pass # Replace with function body.