extends Area2D

signal damage_player(damage)
@export var damage = 10
@export var frequency = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.hide()
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
	$Sprite2D.show()
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.hide()

func do_damage():
	flicker_sprite()
	damage_player.emit(damage)

func _on_timer_timeout():
	do_damage()
