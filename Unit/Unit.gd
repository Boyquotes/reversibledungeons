extends Node2D
class_name Unit
## マップ上のユニットの基礎クラス
## 
## マップ上のユニット(player、Enemy、中立NPC…)に共通する処理

## ユニットの歩行グラフィック
var animation_scene:PackedScene

## Unitのアニメーションを制御するインスタンス
var animation:AnimatedSprite2D

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

## destinationで提示されたマスにUnitを移動する
func update_position(destination:Vector2):
    position_onlevel = destination
    tween = get_tree().create_tween()
    var _propetytween:PropertyTweener = tween.tween_property(self, "position", position_onlevel * _level.tilesize, 0.3)
    tween.play()
    await tween.finished

## Unitの歩行アニメをx,yで指定された方向を示すアニメーションに変更する
func animation_change(x,y):
    var playanim = _animationtype[x+1][y+1]
    if playanim != "None":
        animation.play(playanim)

## ダメージを受けた時の処理[br]
## 現状では攻撃を受けたら死ぬ仕様
func damage():
    # メソッドチェーンをやめろ！！！！
    # ここsignalでもいい気がする
    _level.life_manager.death(self)
    queue_free()
