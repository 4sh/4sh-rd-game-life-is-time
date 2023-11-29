extends Node2D


func _ready():
	Hud.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Screens/Menu/GameMenu.tscn")
