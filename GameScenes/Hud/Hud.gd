extends CanvasLayer

signal restart_game
signal write_finished

@export var show_mental_health: bool = true
@export var has_toggle_world: bool = false

func _on_player_life_changed(life):
	$ingame_ui/lifebar.value = life

func _on_player_mental_health_changed(mental):
	$ingame_ui/mentalhealthbar.value = mental

func show_game_over():
	$ingame_ui.hide()
	$game_over.show()

func _on_game_over_retry_pressed():
	$ingame_ui.show()
	restart_game.emit()

func _on_player_dead():
	show_game_over()

func on_narration_launched(narrationIndex):
	if (Narrations.narrations[narrationIndex].played == true): return
	Narrations.narrations[narrationIndex].played = true
	write(Narrations.narrations[narrationIndex].dialogue)

func write(narrationObject):
	$ingame_ui/dialogbox.show()
	for dialogue in narrationObject:
		$ingame_ui/dialogbox/AudioStreamPlayer.stream = dialogue.sound
		$ingame_ui/dialogbox/AudioStreamPlayer.play()
		$ingame_ui/dialogbox/MarginContainer/Label.text = dialogue.text
		await $ingame_ui/dialogbox/AudioStreamPlayer.finished
	$ingame_ui/dialogbox/MarginContainer/Label.text = ""
	$ingame_ui/dialogbox.hide()
	write_finished.emit()


func _on_ready():
	$ingame_ui/mentalhealthbar.visible = show_mental_health
	$ingame_ui/controls_helper/toggle_world_control.visible = has_toggle_world

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://GameScenes/Screens/Menu/GameMenu.tscn")

func on_worlds_can_toggle_world(can_toggle_world, to_dark):
	$ingame_ui/controls_helper/toggle_world_control/CannotToggleWorldSprite.visible = !can_toggle_world
	$ingame_ui/controls_helper/toggle_world_control/CanToggleWorldSprite.visible = can_toggle_world
	$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.visible = can_toggle_world
	if to_dark:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "sleep"
	else:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "awake"
