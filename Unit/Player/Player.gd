extends Unit
class_name Player

var _menu_ui:DungeonMenuUI
var myturn:bool
var closed:bool
var inventory:Inventory
var isActive:bool = true :set = _set_active

func _init(level:Level, canvas:CanvasLayer):
    animation_scene = preload("res://Unit/Player/Player.tscn")
    self.unit_name = "Player"
    _level = level
    _menu_ui = DungeonMenuUI.new(self, canvas)
    self.inventory = Inventory.new()
    _level.levelnode.add_child(self)

func _set_active(flag:bool):
    isActive = flag
    _switch_process(isActive)

func _switch_process(run:bool):
    if(run == false):
        set_process(false)
    else:
        if(isActive == true):
            set_process(true)

func _process(_delta):
    if myturn == false: return
    if closed == true:
        closed = false
        return
    var _x = 0
    var _y = 0
    var diagonalonly : bool = false
    var changedirection : bool = false
    if Input.is_action_pressed("ui_left"):
        _x -= 1
    if Input.is_action_pressed("ui_right"):
        _x += 1
    if Input.is_action_pressed("ui_up"):
        _y -= 1
    if Input.is_action_pressed("ui_down"):
        _y += 1
    if Input.is_action_pressed("ui_diagonal_only"):
        diagonalonly = true
    if Input.is_action_pressed("ui_change_direction"):
        changedirection = true
    if Input.is_action_just_released("ui_cancel"):
        _menu_ui.open_ui()
        return
    if Input.is_action_pressed("ui_accept"):
        attack()
        return
    # キャンセル+移動同時押しのTween無視対策
    if Input.is_action_pressed("ui_cancel"): return
    if diagonalonly == false and (_x != 0 or _y != 0):
        if changedirection == false:
            try_walk(_x, _y)
        else:
            animation_change(_x,_y)
    elif diagonalonly == true and (_x != 0 and _y != 0):
        if changedirection == false:
            try_walk(_x, _y)
        else:
            animation_change(_x,_y)

func try_walk(dx:int, dy:int):
    var x = position_onlevel.x + dx
    var y = position_onlevel.y + dy
    animation_change(dx,dy)
    if can_move(Vector2(x, y)) == true:
        move(Vector2(x, y))
        after_move()
        action_end()
    pass

func move(destination:Vector2):
    _switch_process(false)
    await super.move(destination)
    _switch_process(true)

## 新しい階層に来た時、初期位置を指定する
func newfloor_warp(position:Vector2):
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.pop_unit(self, position)
    
func get_animation():
    var name = animation.animation
    for x in range(_animationtype.size()):
        var y = _animationtype[x].find(name)
        if y != -1:
            return Vector2(x-1,y-1)
    return Vector2(0,0)

# 位置更新後に呼び出す処理
func after_move():
    await tween.finished
    var cell = _level.get_map_cell(position_onlevel)
    if(cell.stair == true):
        _level.open_stair_ui()
    if cell.item != null:
        self.pick(cell.item)

func attack():
    var direction:Vector2 = get_animation()
    var x = position_onlevel.x + direction.x
    var y = position_onlevel.y + direction.y
    var cell = _level.get_map_cell(Vector2(x,y))
    if(cell.unit != null):
        cell.unit.damage()
    _switch_process(false)
    # todo:ここから下仮設置 将来的に外す
    # 暴発対策にupdate()もどきを入れておいた
    await get_tree().create_timer(0.2).timeout
    _switch_process(true)
    action_end()
    
func pick(drop:DroppedItem):
    # todo:拾わない時(踏んだだけ)の挙動も欲しい
    var item:Item = drop.pick(self)
    if inventory.pick(item):
        # todo:テスト用ログなので正式実装ではない
        _level.GeneralWindow.show_message("{0}を拾った！".format([item.name]))
        drop.delete()

func action():
    myturn = true
    
func action_end():
    myturn = false
    # メソッドチェーンをやめろ！！！！
    _level.turn_manager.action_end()
    pass

## 他のUIに操作を譲る
func pass_focus():
    self.isActive = false

## 他のUIから操作を取得する
func get_focus():
    isActive = true
    closed = true