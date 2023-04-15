class_name DamageObject

## 攻撃者(この攻撃でUnitが倒れた時経験値を得る)
var attacker:Unit

## 攻撃力
var attack:int

## 貫通力
var penetration:int

## 固定ダメージ
var truedamage:int

# todo:状態異常など適宜追加
## 初期化
func _init(attacker:Unit = null, attack:int = 0, penetration:int = 0, truedamage:int = 0):
    self.attacker = attacker
    self.attack = attack
    self.penetration = penetration
    self.truedamage = truedamage
    pass

func show():
    print_debug(self.attacker)
    print_debug(self.attack)
    print_debug(self.penetration)
    print_debug(self.truedamage)
