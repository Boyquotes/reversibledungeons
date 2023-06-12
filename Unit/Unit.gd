extends Node2D
class_name Unit
## マップ上のユニットの基礎クラス
## 
## マップ上のユニット(player、Enemy、中立NPC…)に共通する処理

## ユニットの名前
var unit_name:String

## ユニットの体力の最大値
var max_hp:int

## ユニットの体力
var hp:int

## ユニットの歩行グラフィック
var animation_scene:PackedScene

## Unitのアニメーションを制御するインスタンス
var animation:AnimatedSprite2D

## todo:Vector2iにしたくない？
## Level上にあるこのUnitの座標
var position_onlevel:Vector2

## 非同期処理をするためのインスタンス
var tween:Tween

## マップアクセス時に使用する地形データ
var _level:Level

## アニメーションの変更に使用するアニメ種別の配列
const _animationtype:Array = [
    ["Up-Left","Left","Down-Left"],
    ["Up","None","Down"],
    ["Up-Right","Right","Down-Right"],
    ]

## アニメーションを初期化する
func _ready():
    assert(animation_scene)
    animation = animation_scene.instantiate()
    add_child(animation)
    animation.play()

## destinationに移動可能かどうか_levelに問い合わせる
func can_move(destination:Vector2):
    var cell = _level.get_map_cell(destination)
    if cell.tiletype == _level.Tile.Wall:
        return false
    if cell.unit != null:
        return false
    #todo:ここに角抜け防止処理
    return true

## destinationで提示されたマスにUnitを移動する
func move(destination:Vector2):
    _level.move_unit(self, position_onlevel, destination)
    position_onlevel = destination
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", position_onlevel * _level.tilesize, 0.3)
    tween.play()
    await tween.finished

## Unitの歩行アニメをx,yで指定された方向を示すアニメーションに変更する
func animation_change(x,y):
    var playanim:String = _animationtype[x+1][y+1]
    if playanim != "None":
        if animation.animation != playanim:
            # 方向転換より移動が先に処理されてスライドしてるみたいに見えちゃう現象の対策
            animation.stop()
            animation.play(playanim)
            await animation.animation_changed

## アニメーションから向きを取得する
func get_direction():
    var name = animation.animation
    for x in range(_animationtype.size()):
        var y = _animationtype[x].find(name)
        if y != -1:
            return Vector2(x-1,y-1)
    return Vector2(0,0)

## ダメージを受けた時の処理[br]
## 現状では攻撃を受けたら死ぬ仕様
func damage(damage:DamageObject):
    # メソッドチェーンをやめろ！！！！
    # ここsignalでもいい気がする
    damage.show()
    _level.GeneralWindow.show_message("{0}は倒れた！".format([self.unit_name]))
    _level.life_manager.death(self)
    queue_free()
    
## アイテムを投げる
func throw(item):
    _level.GeneralWindow.show_message("{0}を投げた！".format([item.object_name]))
    ThrowingItem.new(item, _level, self)
    pass

## アイテムを置く
func put(item):
    _level.GeneralWindow.show_message("{0}を置いた".format([item.object_name]))
    DroppedItem.new(item, _level, self.position_onlevel)
    pass
