extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
    var version = Engine.get_version_info()
    text = version.string
