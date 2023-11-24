extends Node2D

@export var heal: int = 10


func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		print("heal")
	else:
		print("no heal")

