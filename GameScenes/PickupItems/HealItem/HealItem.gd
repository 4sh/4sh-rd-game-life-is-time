extends Node2D

@export var heal: int = 5

func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		get_tree().get_first_node_in_group("player").heal(heal)
		queue_free()

