extends Area2D

@export var heal = 10
@export var heal_max = 3
var heal_nb = 0
var can_heal = true

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		heal_player()
		$Timer.start()

func gracefully_stop_sound():
	var tween = create_tween()
	await tween.tween_property($AudioStreamPlayer2D, "volume_db", -500, 2).finished
	$AudioStreamPlayer2D.stop()

func heal_player():
	if (!can_heal): return
	get_tree().get_first_node_in_group("player").heal(heal)
	heal_nb = heal_nb + 1
	create_tween().tween_property($Sprite2D, "self_modulate:v", $Sprite2D.self_modulate.v - 0.1, 0.5)
	if heal_nb == heal_max:
		gracefully_stop_sound()
		can_heal = false

func _on_body_exited(body):
	if body.is_in_group("player"):
		$Timer.stop()
