extends CanvasLayer

signal restart_game
signal write_finished

@export var life_alert_threshold = 30
@export var show_life_health: bool = true:
	set (value):
		show_life_health = value
		$ingame_ui/lifebar.visible = show_life_health
@export var show_mental_health: bool = true:
	set (value):
		show_mental_health = value
		$ingame_ui/mentalhealthbar.visible = show_mental_health
@export var has_toggle_world: bool = true:
	set (value):
		has_toggle_world = value
		$ingame_ui/controls_helper/toggle_world_control.visible = has_toggle_world
@export var has_attack: bool = true:
	set (value):
		has_attack = value
		$ingame_ui/controls_helper/attack_control.visible = has_attack

@onready var sounds = {
	"low_health": preload('res://Assets/Sounds/Trivia/Low_Health.wav')
}

@onready var lifebar_textures = {
	"light_progress": preload("res://Assets/ui/kenney_ui-pack-rpg-expansion/PNG/barGreen_horizontalMid.png"),
	"dark_progress": preload("res://Assets/ui/kenney_ui-pack-rpg-expansion/PNG/barBlack_horizontalMid.png"),
	"light_under": preload("res://Assets/ui/kenney_ui-pack-rpg-expansion/PNG/barBlack_horizontalMid.png"),
	"dark_under": preload("res://Assets/ui/kenney_ui-pack-rpg-expansion/PNG/barGreen_horizontalMid.png")
}

var toggled_world = false
var player_life:int = -1

func _on_ready():
	$ingame_ui/lifebar/hint_label.text = ""
	$ingame_ui/mentalhealthbar/hint_label.text = ""
	
	
func default_setup():
	show_life_health = true
	show_mental_health = true
	has_attack = true
	has_toggle_world = true

func on_player_life_changed(life):
	if (player_life == -1):
		player_life = life 
		$ingame_ui/lifebar.value = life
		return
		
	var life_change = life - player_life
	if (life_change == 0): return
	
	if (life_change < 0):		
		$ingame_ui/lifebar/hint_label.text = str(life_change)
	else:
		$ingame_ui/lifebar/hint_label.text = "+" + str(life_change)

	player_life = life
	var target_lifebar_value
	if toggled_world:					
		target_lifebar_value = (100 - player_life)
	else:
		target_lifebar_value = player_life
	create_tween().tween_property($ingame_ui/lifebar, "value", target_lifebar_value, 0.5)
	
	if player_life <= life_alert_threshold && $ingame_ui/low_life_timer.paused == false:
		animate_low_health()
	else:
		stop_animate_low_health()

	await get_tree().create_timer(1.5).timeout
	$ingame_ui/lifebar/hint_label.text = ""


func animate_low_health():
	$GlobalSounds.stream = sounds.low_health
	$GlobalSounds.play()
	$ingame_ui/low_life_timer.start()

func stop_animate_low_health():
	$GlobalSounds.stop()
	$ingame_ui/low_life_timer.stop()
	$ingame_ui/lifebar.modulate = Color.WHITE

func on_player_mental_health_changed(mental):
	var change = mental - $ingame_ui/mentalhealthbar.value
	if (change == 0): return
	
	if (change < 0):		
		$ingame_ui/mentalhealthbar/hint_label.text = str(change)
	else:
		$ingame_ui/mentalhealthbar/hint_label.text = "+" + str(change)
	
	create_tween().tween_property($ingame_ui/mentalhealthbar, "value", mental, 0.5)
	await get_tree().create_timer(1.5).timeout
	$ingame_ui/mentalhealthbar/hint_label.text = ""

func show_game_over():
	$ingame_ui.hide()
	$game_over.show()

func _on_game_over_retry_pressed():
	$ingame_ui.show()
	$game_over.hide()
	_on_hud_restart_game()

func _on_game_over_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameScenes/Screens/Menu/GameMenu.tscn")

func on_player_dead():
	show_game_over()
	stop_game()

func stop_game():
	get_tree().paused = true

func _on_hud_restart_game():
	Globals.register_failed_level_attempt()
	get_tree().paused = false
	get_tree().reload_current_scene()


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

func on_worlds_toggled_world(to_dark:bool):
	toggled_world = to_dark
	var prefix
	if (to_dark): prefix = "dark"
	else: prefix = "light"
	$ingame_ui/lifebar.texture_progress = lifebar_textures[prefix + "_progress"]
	$ingame_ui/lifebar.texture_under = lifebar_textures[prefix + "_under"]

func _on_low_life_timer_timeout():
	$ingame_ui/lifebar.modulate = $ingame_ui/lifebar.modulate.blend(Color.RED)
	await get_tree().create_timer(0.5).timeout
	$ingame_ui/lifebar.modulate = Color.WHITE


func _on_player_dead():
	show_game_over()
