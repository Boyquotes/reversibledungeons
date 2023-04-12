class_name TurnManage
# todo:Label書き換える用なので将来的には不要かも
extends Node2D
var text:Label
var unit:Array
var lifemanager:LifeManage
var turn:int = 0

func _init(life:LifeManage,text:Label):
    lifemanager = life
    self.text = text
    
func _ready():
    assert(text)
    text.text = "ターン数:{0}".format([turn])
    pass

func action_end():
    var next = unit.pop_back()
    if next == null:
        next_turn()
        # todo:Playerが死んだ時に他の行動させたくない
        if(unit.size() > 0):
            next = unit.pop_back()
        else:
            return
    # todo:多分生存してるUnitが0だとバグる
    next.action()

# todo:たぶんこれUnitをReturnした方が行儀良い
func next_turn():
    turn += 1
    text.text = "ターン数:{0}".format([turn])
    # 配列を壊しながら使うのでディープコピー
    unit = lifemanager.get_alive_unit().duplicate(true)
    # Playerを1番に行動させたい+配列を逆から使いたいので配列の前後を入れ替える
    unit.reverse()
    # todo:ターン終了時の処理をやるならここかも?
    pass
