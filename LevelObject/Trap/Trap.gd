extends LevelObject
class_name Trap

## 動作に必要なクラスを取得する
## todo:罠データをファイルから取得
func _init():
    action_name = "踏む"
    object_name = "テスト用罠"
    infotext = "説明表示テスト用(罠)"
    imagepass = "res://LevelObject/Trap/TrapSample.png"
    
func stepon(stepper):
    ## todo:罠を踏んだ時の処理
    pass
