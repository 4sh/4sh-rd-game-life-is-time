extends Node2D


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Levels/Level 1/Level1.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Screens/Credits/Credits.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
