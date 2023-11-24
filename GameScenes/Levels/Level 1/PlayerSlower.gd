extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$'..'.speed = 0
	create_tween().tween_property($'..', 'speed', 3500, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
