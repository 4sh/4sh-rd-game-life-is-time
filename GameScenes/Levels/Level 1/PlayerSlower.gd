extends Node2D

func _ready():
	var player_speed = $'..'.speed
	$'..'.speed = 8
	await get_tree().create_timer(0.5).timeout
	var hud = $'../../Hud'
	if hud.is_narration_playing():
		await hud.write_finished
	create_tween().tween_property($'..', 'speed', player_speed, 1)
