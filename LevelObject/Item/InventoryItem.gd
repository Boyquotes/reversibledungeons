class_name InventoryItem

var _item:Item
var _inventory:Inventory
var object_name:String

func _init(inventory:Inventory,item:Item):
    item.delete = self.delete
    _item = item
    _inventory = inventory
    object_name = _item.object_name

## アイテムを置く
func put(user:Unit):
    user.put(_item)
    self.delete()

## GUIに渡すために固有操作のボタンを返す
func get_gui_button(user:Unit):
    var result:Array = []
    result.append([_item.action_name,_item.use.bind(user),true])
    result.append(["置く",self.put.bind(user),true])
    result.append(["投げる",_item.throw.bind(user),true])
    return result
    
## インベントリからアイテムを削除する
func delete():
    _inventory.delete(self)
    
# 説明を取得する
func get_information():
    return _item.infotext
