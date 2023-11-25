extends Control

@export var narration:int = 3
@export var level:int = 2

func _ready():
	$Transition.visible = true
	$Splash.visible = false
	$Splash/TextureRect.texture = load("res://Assets/Screens/EnterLevel" + str(level) + ".png")
	$Splash/AudioStreamPlayer2D.stream = load("res://Assets/Sounds/8-bit-halloween-story-166454.mp3")
	$Transition/hud.on_narration_launched(narration)
	await $Transition/hud.write_finished
	$Transition.visible = false
	$Splash.visible = true
	$Splash/AudioStreamPlayer2D.play()
	await get_tree().create_timer(2.5).timeout
	await create_tween().tween_property($Splash/AudioStreamPlayer2D, "attenuation", 5.0, 0.5).finished
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level " + str(level) + "/Level" + str(level) + ".tscn")

