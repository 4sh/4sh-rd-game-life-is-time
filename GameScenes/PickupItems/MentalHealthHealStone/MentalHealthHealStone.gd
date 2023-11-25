extends Node2D

@export var heal: int = 10

func _ready():
	var tween =  create_tween()
	tween.tween_property($Sprite2D, "position:y", -5.0, 0.5)
	await tween.finished
	var tween_2 = create_tween()
	tween_2.tween_property($Sprite2D, "position:y", 0.0, 0.5)
	await tween_2.finished

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		get_tree().get_first_node_in_group("player").mental_heal(heal)
		queue_free()

func _on_up_down_timer_timeout():
	var tween =  create_tween()
	tween.tween_property($Sprite2D, "position:y", -5.0, 0.5)
	await tween.finished
	var tween_2 = create_tween()
	tween_2.tween_property($Sprite2D, "position:y", 0.0, 0.5)
	await tween_2.finished
