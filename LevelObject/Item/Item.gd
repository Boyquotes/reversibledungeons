class_name Item
extends LevelObject

## 動作に必要なクラスを取得する
## playerというよりは所有者な気もする 将来的にunitに変更?
## todo:itemはどのアイテムか判別さえできればOK 将来的にはitemIDとかで区別
func _init():
    action_name = "使う"
    object_name = "テスト用アイテム"
    infotext = "説明表示テスト用"
    imagepass = "res://LevelObject/Item/ItemSample.png"

## アイテムに対する固有の動作
func use(user:Unit):
    ## ここに使った時の挙動入れる
    delete.call()
    #_window.show_message("{0}を使った！".format([self.name]))

## アイテムを投げる
func throw(thrower:Unit):
    delete.call()
    thrower.throw(self)
    pass

## アイテムを投げて当たった時の動作
func clash(thrower:Unit,unit:Unit):
    # todo:投げて当たった時の動作
    var damage = DamageObject.new(thrower)
    unit.damage(damage)
    # todo:命中しなかったor敵にぶつかっても壊れるタイプのアイテムじゃなかった場合、Drop()
    delete.call()
    pass
