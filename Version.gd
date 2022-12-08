extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
    var version = Engine.get_version_info()
    text = version.string


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
