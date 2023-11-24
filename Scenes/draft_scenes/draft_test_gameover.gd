extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hud_restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_timer_timeout():
	$Player.hit(10)

func _on_player_dead():
	stop_game()

func stop_game():
	get_tree().paused = true
