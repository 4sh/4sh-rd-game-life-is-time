extends Node2D


func _ready():
	# $Player.position = Vector2(530,545) # test level end
	pass

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


func _on_sleep_travel_stone_body_entered(body):
	if body.is_in_group("player"):
		$World/Items/SleepTravelStone/Sprite2D.queue_free()
		$Hud.has_toggle_world = true
		$World/Items/SleepTravelStone.queue_free()
		$Hud.help_text("Appuyer sur espace pour utiliser la pierre de sommeil")

func _unhandled_input(event):
	if Input.is_action_just_pressed("toggle_dark_world") and $Hud.has_toggle_world:
		end_level()

func end_level():
	await create_tween().tween_property($AudioStreamPlayer, 'volume_db', -10, 1).finished
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 3/EnterLevel3.tscn")
