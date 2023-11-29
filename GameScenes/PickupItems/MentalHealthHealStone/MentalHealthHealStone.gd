extends Node2D

@export var heal: int = 10

func _ready():
	await create_tween().tween_property($Sprite2D, "position:y", -5.0, 0.5).finished
	create_tween().tween_property($Sprite2D, "position:y", 0.0, 0.5)

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		get_tree().get_first_node_in_group("player").mental_heal(heal)
		queue_free()

func _on_up_down_timer_timeout():
	await create_tween().tween_property($Sprite2D, "position:y", -5.0, 0.5).finished
	create_tween().tween_property($Sprite2D, "position:y", 0.0, 0.5)
