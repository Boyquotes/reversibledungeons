extends Control
var base_container:ItemMenuUI

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


func _on_button_pressed(num:int):
    base_container.open_itemactionui(num)
    pass # Replace with function body.
