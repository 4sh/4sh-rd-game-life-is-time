extends Area2D

@export var damage = 10
@export var frequency = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.self_modulate.a = 0.0
	$Timer.wait_time = frequency

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		do_damage()
		$Timer.start()

func _on_body_exited(body):
	if body.is_in_group("player"):
		$Timer.stop()

func flicker_sprite():
	$Sprite2D.self_modulate.a = 0.0
	create_tween().tween_property($Sprite2D, "self_modulate:a", 1.0, 0.1)
	$Sprite2D.self_modulate.lerp(Color.WHITE, 0.2)
	await get_tree().create_timer(0.2).timeout
	create_tween().tween_property($Sprite2D, "self_modulate:a", 0.0, 0.1)

func do_damage():
	flicker_sprite()
	get_tree().get_first_node_in_group("player").hit(damage)

func _on_timer_timeout():
	do_damage()
