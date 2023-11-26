extends Node2D

func _ready():
	$World/DiseaseTimer.stop()
	$Player/Camera2D.zoom = Vector2(0.8,0.8)
	$Player/Camera2D.offset = Vector2(0,-350)
	get_tree().create_timer(3.0).connect("timeout", Callable(self, "play_cursed"))
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, -200), 1.5)
	await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(1.5, 1.5), 1.5).finished
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, 0), 3)
	create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(4, 4), 3)
	var hud = $Hud
	if hud.is_narration_playing():
		await hud.write_finished
	$AudioStreamPlayer.play()


func play_cursed():
	$Cursed.color.a = 0.0
	$Cursed.visible = true
	for n in 3:
		await create_tween().tween_property($Cursed, 'color:a', 1.0, 0.25).finished
		await create_tween().tween_property($Cursed, 'color:a', 0.0, 0.25).finished
		await get_tree().create_timer(0.2).timeout
	$Cursed.visible = false
	$World/DiseaseTimer.start()
	

func _process(delta):
	pass


func _on_player_dead():
	stop_game()

func stop_game():
	get_tree().paused = true

func _on_hud_restart_game():
	Globals.register_failed_level_attempt()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_portal_body_entered(body):
	create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(1, 1), 3)
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, 100), 3)

	$Player.paused = true
	$World/DiseaseTimer.stop()	
	await $Hud.write_finished
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 2/EnterLevel2.tscn")
