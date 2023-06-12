class_name DroppedItem
extends DroppedObject

var _item:Item

## todo:itemはどのアイテムか判別さえできればOK 将来的にはitemIDとかで区別
func _init(item:Item, level:Level, position:Vector2):
    sprite = Sprite2D.new()
    var texture = load(item.imagepass)
    sprite.set_texture(texture)
    sprite.centered = false
    self.add_child(sprite)
    _item = item
    _level = level
    object_name = _item.object_name
    _item.delete = Callable(self.delete)
    self.position_onlevel = position
    self.position = position * _level.tilesize
    _level.levelnode.add_child(self)
    _level.pop_item(self, position_onlevel)
        
## アイテムを踏んだ時の挙動
func stepon(_stepper):
    if _stepper is Player:
        pick(_stepper)
    pass

## アイテムを拾う
func pick(_picker:Player):
    if _picker.pick(_item):
        self.delete()
    pass

## GUIに渡すために固有操作のボタンを返す
func get_gui_button(user:Unit):
    var result:Array = []
    result.append(["拾う",self.pick.bind(user),true])
    result.append([_item.action_name,_item.use.bind(user),true])
    result.append(["投げる",_item.throw.bind(user),true])
    return result
    
# 説明を取得する
func get_information():
    return _item.infotext
