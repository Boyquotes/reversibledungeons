extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func _draw():
    var screen_size = get_viewport().get_size()
    var center = screen_size / 2
    draw_line(Vector2(center.x, 0), Vector2(center.x, screen_size.y), Color(0, 0, 0))
    draw_line(Vector2(0, center.y), Vector2(screen_size.x, center.y), Color(0, 0, 0))
