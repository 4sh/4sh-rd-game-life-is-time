extends CanvasLayer

signal restart_game
signal write_finished

@export var life_alert_threshold = 30
@export var show_mental_health: bool = true
@export var has_toggle_world: bool = false:
	set (value):
		has_toggle_world = value
		$ingame_ui/controls_helper/toggle_world_control.visible = has_toggle_world

@onready var sounds = {
	"low_health": preload('res://Assets/Sounds/Trivia/Low_Health.wav')
}

func _on_player_life_changed(life):
	$ingame_ui/lifebar.value = life
	if $ingame_ui/lifebar.value <= life_alert_threshold && $GlobalSounds.playing == false:
		animate_low_health()
	else:
		stop_animate_low_health()

func animate_low_health():
	$GlobalSounds.stream = sounds.low_health
	$GlobalSounds.play()
	$ingame_ui/low_life_timer.start()

func stop_animate_low_health():
	$GlobalSounds.stop()
	$ingame_ui/low_life_timer.stop()
	$ingame_ui/lifebar.modulate = Color.WHITE

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

func is_narration_playing():
	return $ingame_ui/dialogbox.visible

func help_text(text):
	$ingame_ui/dialogbox.show()
	$ingame_ui/dialogbox/MarginContainer/Label.text = text
	await get_tree().create_timer(3).timeout
	$ingame_ui/dialogbox.hide()

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
	$ingame_ui/controls_helper/toggle_world_control/Help.visible = can_toggle_world
	if to_dark:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "sleep"
	else:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "awake"


func _on_low_life_timer_timeout():
	$ingame_ui/lifebar.modulate = $ingame_ui/lifebar.modulate.blend(Color.RED)
	await get_tree().create_timer(0.5).timeout
	$ingame_ui/lifebar.modulate = Color.WHITE
