extends Control
var base_container:ItemInfo

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
