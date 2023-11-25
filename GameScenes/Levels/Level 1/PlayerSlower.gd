extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$'..'.speed = 0
	await create_tween().tween_property($'..', 'speed', 1000, 10).finished
	create_tween().tween_property($'..', 'speed', 3500, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
