class_name LifeManage
var alive:Array
# 蘇生判定作るなら別の関数作って対応
    
func append(unit):
    alive.append(unit)

func death(unit):
    alive.erase(unit)

func get_alive_unit():
    return alive
