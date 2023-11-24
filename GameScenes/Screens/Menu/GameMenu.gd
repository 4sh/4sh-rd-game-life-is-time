extends Node2D


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 1/Level1.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Screens/Credits/Credits.tscn")
