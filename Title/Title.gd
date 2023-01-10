extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if Input.is_anything_pressed():
        #まだダンジョン突入までの導線を作っていないのでダンジョンに直接移動
        get_tree().change_scene_to_file("res://Level/Dungeon.tscn")
    pass
    

