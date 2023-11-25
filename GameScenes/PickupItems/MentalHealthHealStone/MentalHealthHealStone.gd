extends Node2D

@export var heal: int = 10

var tween

func _ready():
	tween = create_tween()
	while(true):
		tween.tween_property($Sprite2D, "position:y", -5.0, 1.0)
		await tween.finished
		tween.tween_property($Sprite2D, "position:y", 0.0, 1.0)
		await tween.finished

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		get_tree().get_first_node_in_group("player").mental_heal(heal)
		queue_free()

