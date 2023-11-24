extends CanvasLayer

signal restart_game

func _on_player_life_changed(life):
	$ingame_ui/lifebar.value = life

func show_game_over():
	$ingame_ui.hide()
	$game_over.show()

func _on_game_over_retry_pressed():
	$ingame_ui.show()
	restart_game.emit()

func _on_player_dead():
	show_game_over()
