extends Node2D


@onready var end_portal = $Worlds/Light/Items/PortalPillar

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

var low_mental_health_help_shown = false
func _on_player_mental_health_changed(mental_health):
	if (!low_mental_health_help_shown and mental_health <= 60):
		$Hud.help_text("Surveille bien ta santé mentale, Teils.\nElle diminue à chaque passage du côté sombre, et pourrait bien entraîner ta mort...")
		# wait a few seconds before blinking, so that player has time to read the help text
		await get_tree().create_timer(2).timeout
		$Hud.blink_mental_health()
		low_mental_health_help_shown = true
	if (mental_health <= $Player.mental_damage_on_move_to_dark):
		$Hud.help_text("Ta santé mentale s'épuise Teils. Un autre passage vers le côté sombre et ce sera ta mort...")
		# wait a few seconds before blinking, so that player has time to read the help text
		await get_tree().create_timer(2).timeout
		$Hud.blink_mental_health()
		
var low_life_help_shown = false
func _on_player_life_changed(life):
	if (!low_life_help_shown and life <= 30):
		$Hud.help_text("Surveille bien ta vie, Teils.\nEt observe comment elle bascule à chaque passage de l'autre côté...")
		low_life_help_shown = true
		
		
func _on_portal_pillar_player_entered_active_portal():
	$Hud.help_text("Vous avez trouvé une pierre mentale...")
	$Player.paused = true
	$Player.mental_heal(100)
	$Worlds/Light/DiseaseTimer.stop()	
	create_tween().tween_property($Player/Camera2D, 'offset', Vector2(-200, -200), 1.5)
	await create_tween().tween_property($Player/Camera2D, 'zoom', Vector2(0.75, 0.75), 2).finished

	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 4/EnterLevel4.tscn")


func _on_activate_portal_body_entered(body):
	if body.is_in_group("player"):
		end_portal.activate()
