extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		var tween_up = create_tween()
		tween_up.tween_property(self, "position:y", -5.0, 1.0)
		await tween_up.finished
		var tween_down = create_tween()
		tween_down.tween_property(self, "position:y", 0.0, 1.0)
		await tween_down.finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
