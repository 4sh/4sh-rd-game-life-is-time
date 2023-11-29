extends Node2D

func _on_player_dead():
	stop_game()

func stop_game():
	get_tree().paused = true

func _on_hud_restart_game():
	Globals.register_failed_level_attempt()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_the_sword_area_body_entered(body):
	if body.is_in_group("player"):
		$Hud.help_text("Vous avez trouvé l'épée mentale...")
		$Player.can_attack = true
		$Player.mental_heal(100)
		if ($Player.life < 70):
			$Player.heal(70 - $Player.life)
		$Hud.has_attack = true
		$Worlds/Light/Items/TheSword.queue_free()
		await get_tree().create_timer(1.5).timeout
		$Hud.show_attack_help()


func _on_the_end_area_body_entered(body):
	if body.is_in_group("player"):
		$Hud.help_text("Vous avez trouvé la porte vers ... l'autre côté")
		$Player.paused = true
		$Player.invulnerable = true
		$Worlds/Light/DiseaseTimer.stop()	
		create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, -500), 2.5)
		await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(0.5, 0.5), 3).finished

		get_tree().change_scene_to_file("res://GameScenes/Levels/Level 5/EnterLevel5.tscn")
		


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
