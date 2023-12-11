extends CharacterBody2D

func hit(damage, direction):
	$BarrierSprite.play()

func _on_barrier_sprite_animation_finished():
	queue_free()

func _on_approach_barrier_detector_body_entered(body):
	if (body.is_in_group("player")):
		get_tree().get_first_node_in_group("hud").help_text("il te faut une arme pour briser cette barrière")
