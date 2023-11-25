extends Node2D


func _on_the_sword_area_body_entered(body):
	if body.is_in_group("player"):
		$Hud.help_text("Vous avez trouvé l'épée mentale...")
		$Player.can_attack = true
		$Player.mental_heal(100)
		$Player.heal(100)
		$Hud.has_attack = true
		$Worlds/Light/Items/TheSword.queue_free()
