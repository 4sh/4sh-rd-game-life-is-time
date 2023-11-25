extends Node2D


func _ready():
	$Player/Camera2D.zoom = Vector2(0.8,0.8)
	$Player/Camera2D.offset = Vector2(0,-350)
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, -200), 1.5)
	await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(1.5, 1.5), 1.5).finished
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, 0), 3)
	create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(4, 4), 3)


func _process(delta):
	pass


func _on_player_dead():
	stop_game()

func stop_game():
	get_tree().paused = true

func _on_hud_restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_portal_body_entered(body):
	create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(1, 1), 3)
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(0, 100), 3)

	$Player.paused = true
	$World/DiseaseTimer.stop()	
	await $Hud.write_finished
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 2/EnterLevel2.tscn")
