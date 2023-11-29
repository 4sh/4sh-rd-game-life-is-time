extends Node2D


func _ready():
	# $Player.position = Vector2(460,1760)
	Hud.has_attack = false


func _on_end_level_body_entered(body):
	if body.is_in_group("player"):
		Hud.help_text("Vous avez trouvé une pierre mentale...")
		$Player.paused = true
		$Player.mental_heal(100)
		$Worlds/Light/DiseaseTimer.stop()	
		create_tween().tween_property($Player/Camera2D, 'offset', Vector2(-200, -200), 1.5)
		await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(0.75, 0.75), 2).finished

		get_tree().change_scene_to_file("res://GameScenes/Levels/Level 4/EnterLevel4.tscn")
