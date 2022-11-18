extends Node2D

var rooms = []
var map = []
onready var tile_map = $TileMap
enum Tile {TileOrange ,TileBlue}
var level_size = Vector2(30, 30)
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8
var enemy_pathfinding

func _ready():
    randomize()
    # build_level()
    #var mapdata = [
    #[Tile.TileOrange,Tile.TileOrange,Tile.TileOrange,Tile.TileOrange,Tile.TileOrange],
    #[Tile.TileBlue,Tile.TileBlue,Tile.TileBlue,Tile.TileBlue,Tile.TileBlue],
    #[Tile.TileOrange,Tile.TileOrange,Tile.TileOrange,Tile.TileOrange,Tile.TileOrange],
    #[Tile.TileBlue,Tile.TileBlue,Tile.TileBlue,Tile.TileBlue,Tile.TileBlue]
    #]
    
    var mapdata = [
        [],
        [1,0,0,0,0,0],
        [1,0,0,0,0,0,0],
        [1,0,0,0,0,0],
    ]
    buildLevelFromData(Vector2i(10,10), mapdata)

# mapdataから地形を生成する
# mapdata:生成する地形のデータ(int型2次元配列)
func buildLevelFromData(size:Vector2i, mapdata:Array):
    rooms.clear()
    map.clear()
    tile_map.clear()
    
    enemy_pathfinding = AStar3D.new()
    var bluetile:Array = []
    var whitetile:Array = []
    
    for x in range(size.x):
        map.append([])
        for y in range(size.y):
            # todo:mapの使用用途なんだっけ?
            map[x].append(Tile.TileBlue)
            bluetile.append(Vector2i(x, y))
    
    for y in range(mapdata.size()):
        for x in range(mapdata[y].size()):
            if mapdata[y][x] == 0:
                whitetile.append(Vector2i(x, y))
            
    #tile_map.update_bitmask_region()
    tile_map.set_cells_terrain_connect(0, bluetile, 0, 1)
    tile_map.set_cells_terrain_connect(0, whitetile, 0, 0)

func build_level():
    # Start with a blank map
    
    rooms.clear()
    map.clear()
    tile_map.clear()
    
    # このへんの処理はMapのテストでは使わないからコメントアウトしとこ
    # for enemy in enemies:
    #     enemy.remove_at()
    # enemies.clear()
    
    # for item in items:
    #     item.remove_at()
    # items.clear()
    
    enemy_pathfinding = AStar3D.new()
    
    # Randomize can effects
    
    # can_types = CAN_FUNCTIONS.duplicate()
    # can_types.shuffle()
    
    for x in range(level_size.x):
        map.append([])
        for y in range(level_size.y):
            map[x].append(Tile.TileBlue)
            tile_map.set_cell(x, y, Tile.TileBlue)
            # visibility_mapは今は使わない
            # visibility_map.set_cell(x, y, 0)

    var free_regions = [Rect2(Vector2i(2, 2), level_size - Vector2i(4, 4))]
    var num_rooms = 6
    for _i in range(num_rooms):
        add_room(free_regions)
        if free_regions.is_empty():
            break
            
    connect_rooms()
    tile_map.update_bitmask_region()
    

func connect_rooms():
    # Build an AStar3D graph of the area where we can add corridors
    
    var stone_graph = AStar3D.new()
    var point_id = 0
    for x in range(level_size.x):
        for y in range(level_size.y):
            if map[x][y] == Tile.TileBlue:
                stone_graph.add_point(point_id, Vector3(x, y, 0))
                
                # Connect to left if also stone
                if x > 0 && map[x - 1][y] == Tile.TileBlue:
                    var left_point = stone_graph.get_closest_point(Vector3(x - 1, y, 0))
                    stone_graph.connect_points(point_id, left_point)
                    
                # Connect to above if also stone
                if y > 0 && map[x][y - 1] == Tile.TileBlue:
                    var above_point = stone_graph.get_closest_point(Vector3(x, y - 1, 0))
                    stone_graph.connect_points(point_id, above_point)
                    
                point_id += 1

    # Build an AStar3D graph of room connections
    
    var room_graph = AStar3D.new()
    point_id = 0
    for room in rooms:
        var room_center = room.position + room.size / 2
        room_graph.add_point(point_id, Vector3(room_center.x, room_center.y , 0))
        point_id += 1
    
    # Add random connections until everything is connected
    
    while !is_everything_connected(room_graph):
        add_random_connection(stone_graph, room_graph)

func is_everything_connected(graph):
    var points = graph.get_points()
    var start = points.pop_back()
    for point in points:
        var path = graph.get_point_path(start, point)
        if !path:
            return false
            
    return true

func add_room(free_regions):
    var region = free_regions[randi() % free_regions.size()]
        
    var size_x = MIN_ROOM_DIMENSION 
    if region.size.x > MIN_ROOM_DIMENSION:
        size_x += randi() % int(region.size.x - MIN_ROOM_DIMENSION)
    
    var size_y = MIN_ROOM_DIMENSION
    if region.size.y > MIN_ROOM_DIMENSION:
        size_y += randi() % int(region.size.y - MIN_ROOM_DIMENSION)
        
    size_x = min(size_x, MAX_ROOM_DIMENSION)
    size_y = min(size_y, MAX_ROOM_DIMENSION)
        
    var start_x = region.position.x
    if region.size.x > size_x:
        start_x += randi() % int(region.size.x - size_x)
        
    var start_y = region.position.y
    if region.size.y > size_y:
        start_y += randi() % int(region.size.y - size_y)
    
    var room = Rect2(start_x, start_y, size_x, size_y)
    rooms.append(room)
    
    for x in range(start_x, start_x + size_x):
        set_tile(x, start_y, Tile.TileBlue)
        set_tile(x, start_y + size_y - 1, Tile.TileBlue)
        
    for y in range(start_y + 1, start_y + size_y - 1):
        set_tile(start_x, y, Tile.TileBlue)
        set_tile(start_x + size_x - 1, y, Tile.TileBlue)
        
        for x in range(start_x + 1, start_x + size_x - 1):
            set_tile(x, y, Tile.TileOrange)
            
    cut_regions(free_regions, room)

func cut_regions(free_regions, region_to_remove):
    var removal_queue = []
    var addition_queue = []
    
    for region in free_regions:
        if region.intersects(region_to_remove):
            removal_queue.append(region)
            
            var leftover_left = region_to_remove.position.x - region.position.x - 1
            var leftover_right = region.end.x - region_to_remove.end.x - 1
            var leftover_above = region_to_remove.position.y - region.position.y - 1
            var leftover_below = region.end.y - region_to_remove.end.y - 1
            
        
            if leftover_left >= MIN_ROOM_DIMENSION:
                addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
            if leftover_right >= MIN_ROOM_DIMENSION:
                addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
            if leftover_above >= MIN_ROOM_DIMENSION:
                addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
            if leftover_below >= MIN_ROOM_DIMENSION:
                addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
                
    for region in removal_queue:
        free_regions.erase(region)
        
    for region in addition_queue:
        free_regions.append(region)
        
func add_random_connection(stone_graph, room_graph):
    # Pick rooms to connect

    var start_room_id = get_least_connected_point(room_graph)
    var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
    
    # Pick door locations
    
    var start_position = pick_random_door_location(rooms[start_room_id])
    var end_position = pick_random_door_location(rooms[end_room_id])
    
    # Find a path to connect the doors to each other
    
    var closest_start_point = stone_graph.get_closest_point(start_position)
    var closest_end_point = stone_graph.get_closest_point(end_position)
    
    var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
    assert(path)
    
    # Add path to the map
    
    path = Array(path)
    
    set_tile(start_position.x, start_position.y, Tile.TileOrange)
    set_tile(end_position.x, end_position.y, Tile.TileOrange)
    
    for pos in path:
        set_tile(pos.x, pos.y, Tile.TileOrange)
    
    room_graph.connect_points(start_room_id, end_room_id)    


func get_least_connected_point(graph):
    var point_ids = graph.get_points()
    
    var least
    var tied_for_least = []
    
    for point in point_ids:
        var count = graph.get_point_connections(point).size()
        if !least || count < least:
            least = count
            tied_for_least = [point]
        elif count == least:
            tied_for_least.append(point)
            
    return tied_for_least[randi() % tied_for_least.size()]
    
func get_nearest_unconnected_point(graph, target_point):
    var target_position = graph.get_point_position(target_point)
    var point_ids = graph.get_points()
    
    var nearest
    var tied_for_nearest = []
    
    for point in point_ids:
        if point == target_point:
            continue
        
        var path = graph.get_point_path(point, target_point)
        if path:
            continue
            
        var dist = (graph.get_point_position(point) - target_position).length()
        if !nearest || dist < nearest:
            nearest = dist
            tied_for_nearest = [point]
        elif dist == nearest:
            tied_for_nearest.append(point)
            
    return tied_for_nearest[randi() % tied_for_nearest.size()]

func pick_random_door_location(room):
    var options = []
    
    # Top and bottom walls
    
    for x in range(room.position.x + 1, room.end.x - 2):
        options.append(Vector3(x, room.position.y, 0))
        options.append(Vector3(x, room.end.y - 1, 0))
            
    # Left and right walls
    
    for y in range(room.position.y + 1, room.end.y - 2):
        options.append(Vector3(room.position.x, y, 0))
        options.append(Vector3(room.end.x - 1, y, 0))
            
    return options[randi() % options.size()]
    
func set_tile(x, y, type):
    map[x][y] = type
    tile_map.set_cell(x, y, type)

    if type == Tile.TileOrange:
        clear_path(Vector2(x, y))
        
func clear_path(tile):
    var new_point = enemy_pathfinding.get_available_point_id()
    enemy_pathfinding.add_point(new_point, Vector3(tile.x, tile.y, 0))
    var points_to_connect = []
    
    if tile.x > 0 && map[tile.x - 1][tile.y] == Tile.TileOrange:
        points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x - 1, tile.y, 0)))
    if tile.y > 0 && map[tile.x][tile.y - 1] == Tile.TileOrange:
        points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y - 1, 0)))
    if tile.x < level_size.x - 1 && map[tile.x + 1][tile.y] == Tile.TileOrange:
        points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x + 1, tile.y, 0)))
    if tile.y < level_size.y - 1 && map[tile.x][tile.y + 1] == Tile.TileOrange:
        points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y + 1, 0)))
        
    for point in points_to_connect:
        enemy_pathfinding.connect_points(point, new_point)
