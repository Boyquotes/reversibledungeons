class_name Inventory

# Itemを溜めておくための配列
var _items:Array[Item] = []
var _maxsize:int

func _init(max:int):
    _maxsize = max

## アイテムを拾う
func pick(item:Item):
    if _items.size() >= _maxsize:
        return false
    else:
        _items.append(item)
        return true   

## システムからアイテムを追加する
## 現状pick()と同様の処理だが、そのうち枝分かれしていくと思う
func add(item:Item):
    if _items.size() >= _maxsize:
        return false
    else:
        _items.append(item)
        return true
        
## _itemsからアイテムを削除する
func delete(item:Item):
    _items.erase(item)

## アイテムの一覧を取得する
func get_list():
    return _items
    
## 特定のアイテムを取得する
func get_item(index:int):
    return _items[index]


