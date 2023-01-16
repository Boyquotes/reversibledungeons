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
    pass
    
func _ready():
    assert(text)
    print_debug("TurnManage.Ready")
    text.text = "ターン数:{0}".format([turn])
    action_end()
    pass

func action_end():
    var next = unit.pop_back()
    if next == null:
        next_turn()
        # このif文無いと敵の攻撃でスタックオーバーフローする
        # Playerが死んだ時にtrueの判定させたい
        if(unit.size() > 1):
            next = unit.pop_back()
        else:
            return
    # todo:多分生存してるUnitが0だとバグる
    next.Action()

# たぶんこれUnitをReturnした方が行儀良い
func next_turn():
    turn += 1
    text.text = "ターン数:{0}".format([turn])
    # 配列を壊しながら使うのでディープコピー
    unit = lifemanager.alive.duplicate(true)
    # Playerを1番に行動させたい+配列を逆から使いたいので配列の前後を入れ替える
    unit.reverse()
    # todo:ターン終了時の処理をやるならここかも?
    pass
