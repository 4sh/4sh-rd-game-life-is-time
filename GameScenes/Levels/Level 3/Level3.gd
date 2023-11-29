extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# $Player.position = Vector2(460,1760)
	pass


func _on_player_dead():
	stop_game()

func stop_game():
	get_tree().paused = true

func _on_hud_restart_game():
	Globals.register_failed_level_attempt()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_end_level_body_entered(body):
	if body.is_in_group("player"):
		$Hud.help_text("Vous avez trouvé une pierre mentale...")
		$Player.paused = true
		$Player.mental_heal(100)
		$Worlds/Light/DiseaseTimer.stop()	
		create_tween().tween_property($Player/Camera2D, 'offset', Vector2(-200, -200), 1.5)
		await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(0.75, 0.75), 2).finished

		get_tree().change_scene_to_file("res://GameScenes/Levels/Level 4/EnterLevel4.tscn")


func _on_toggle_world_help_detector_body_entered(body):
	if (body.is_in_group("player")):
		$Hud/ToggleWorldHelpTimer.start()

func _on_toggle_world_help_detector_body_exited(body):
	if (body.is_in_group("player")):
		$Hud/ToggleWorldHelpTimer.stop()	

func _on_toggle_world_help_timer_timeout():
	get_tree().call_group("hud", "show_toggle_world_help")


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
