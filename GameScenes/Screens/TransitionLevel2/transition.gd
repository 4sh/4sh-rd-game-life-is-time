extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$hud.on_narration_launched(3)
	await $hud.write_finished
	get_tree().change_scene_to_file("res://GameScenes/Screens/EnterLevel2/EnterLevel2.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
