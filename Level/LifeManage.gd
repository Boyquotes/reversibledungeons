class_name LifeManage
var player_is_alive:bool = true
var _alive:Array
# 蘇生判定作るなら別の関数作って対応

func append(unit):
    _alive.append(unit)

func death(unit):
    if unit is Player:
        player_is_alive = false 
        unit.get_tree().change_scene_to_file("res://Title/Title.tscn")
    _alive.erase(unit)

func get_alive_unit():
    if player_is_alive == true:
        return _alive
    else:
        # Playerが死んでいる時に敵のみの配列を渡すとスタックオーバーフローする
        return Array()
