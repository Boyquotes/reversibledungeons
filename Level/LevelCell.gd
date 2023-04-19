class_name LevelCell
## マップのCell1つ1つを表すデータ

# 適宜追加
## Cellの属性(地形)
var tiletype:Level.Tile

## Cellに乗っているUnit
var unit:Unit

## Cellに乗っているItem、罠など
var droppedobject:DroppedObject

func _init(type:Level.Tile):
    tiletype = type
