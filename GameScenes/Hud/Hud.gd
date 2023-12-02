extends CanvasLayer

signal restart_game
signal write_finished

@export var life_alert_threshold = 30
@export var show_life_health: bool = true
@export var show_mental_health: bool = true
@export var has_toggle_world: bool = false:
	set (value):
		has_toggle_world = value
		if $ingame_ui/controls_helper/toggle_world_control:
			$ingame_ui/controls_helper/toggle_world_control.visible = has_toggle_world
@export var has_attack: bool = false:
	set (value):
		has_attack = value
		if $ingame_ui/controls_helper/attack_control:
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
var keep_help_open = false

func _on_player_life_changed(life):
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

func blink_mental_health():
	var tween = create_tween()
	for n in 4:
		tween.tween_property($ingame_ui/mentalhealthbar, "modulate:s", 0.5, 0.4)
		tween.tween_property($ingame_ui/mentalhealthbar, "modulate:s", 0, 0.4)
		tween.tween_interval(0.2)

func _on_player_mental_health_changed(mental):
	var change = mental - $ingame_ui/mentalhealthbar.value
	if (change == 0): return
	
	var tween_duration
	if (change < 0):		
		$ingame_ui/mentalhealthbar/hint_label.text = str(change)
		tween_duration = 0.5
	else:
		$ingame_ui/mentalhealthbar/hint_label.text = "+" + str(change)
		tween_duration = 2
	
	create_tween().tween_property($ingame_ui/mentalhealthbar, "value", mental, tween_duration)
	await get_tree().create_timer(1.5).timeout
	$ingame_ui/mentalhealthbar/hint_label.text = ""

func show_game_over():
	$ingame_ui.hide()
	$game_over.show()

func _on_game_over_retry_pressed():
	$ingame_ui.show()
	restart_game.emit()

func _on_game_over_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameScenes/Screens/Menu/GameMenu.tscn")

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

func clear_dialog():
	$ingame_ui/dialogbox.hide()

func help_text(text):
	$ingame_ui/dialogbox.show()
	$ingame_ui/dialogbox/MarginContainer/Label.text = text
	await get_tree().create_timer(3).timeout
	$ingame_ui/dialogbox.hide()

func _on_ready():
	$ingame_ui/lifebar.visible = show_life_health
	$ingame_ui/mentalhealthbar.visible = show_mental_health
	$ingame_ui/controls_helper/toggle_world_control.visible = has_toggle_world
	$ingame_ui/controls_helper/attack_control.visible = has_attack
	$ingame_ui/lifebar/hint_label.text = ""
	$ingame_ui/mentalhealthbar/hint_label.text = ""

func _unhandled_input(event):
	if Input.is_action_just_pressed("hud_help"):
		show_hud_help()
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://GameScenes/Screens/Menu/GameMenu.tscn")
		elif event.pressed:
			if !keep_help_open and $ingame_ui/hud_help.visible:
				$ingame_ui/hud_help.hide()
				$ingame_ui/hud_help/controls_helper/toggle_world_control.hide()
				$ingame_ui/hud_help/controls_helper/attack_control.hide()

func show_hud_help():	
	if (!has_toggle_world):
		return
	if !$ingame_ui/hud_help.visible:
		$ingame_ui/hud_help.show()
		$ingame_ui/hud_help/controls_helper/toggle_world_control.show()
	elif $ingame_ui/hud_help/controls_helper/toggle_world_control.visible:
		$ingame_ui/hud_help/controls_helper/toggle_world_control.hide()
		if (has_attack):
			$ingame_ui/hud_help/controls_helper/attack_control.show()
		else: 
			$ingame_ui/hud_help.hide()
	elif $ingame_ui/hud_help/controls_helper/attack_control.visible:
		$ingame_ui/hud_help/controls_helper/attack_control.hide()
		$ingame_ui/hud_help.hide()

func show_toggle_world_help():
	$ingame_ui/hud_help.show()
	$ingame_ui/hud_help/controls_helper/toggle_world_control.show()
	keep_help_open = true
	$ingame_ui/hud_help/KeepHelpOpenTimer.start()
	
func show_attack_help():
	$ingame_ui/hud_help.show()
	$ingame_ui/hud_help/controls_helper/attack_control.show()
	keep_help_open = true
	$ingame_ui/hud_help/KeepHelpOpenTimer.start()

func _on_keep_help_open_timer_timeout():
	keep_help_open = false	

func on_worlds_can_toggle_world(can_toggle_world, to_dark):
	$ingame_ui/controls_helper/toggle_world_control/CannotToggleWorldSprite.visible = !can_toggle_world
	$ingame_ui/controls_helper/toggle_world_control/CanToggleWorldSprite.visible = can_toggle_world
	$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.visible = can_toggle_world
	$ingame_ui/controls_helper/toggle_world_control/Help.visible = can_toggle_world
	if to_dark:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "sleep"
	else:
		$ingame_ui/controls_helper/toggle_world_control/ToggleWorldLabel.text = "awake"

func _on_worlds_toggled_world(to_dark:bool):
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

