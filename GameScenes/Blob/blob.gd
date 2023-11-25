extends CharacterBody2D

@export var SPEED = 30.0
@export var damage = 10
@export var max_distance = 100
@export var life = 20.0

@onready var player = get_tree().get_first_node_in_group("player") 

func _ready():
	$AnimatedSprite2D.animation = 'front'
	$AnimatedSprite2D.play()

func get_player_pos():
	return player.position

func _process(delta):
	var player_pos: Vector2 = get_player_pos()
	var direction = (player_pos - position)
	var is_in_range = direction.length() < max_distance
	direction = direction.normalized()
	
	if abs(direction.y) > abs(direction.x):
		$AnimatedSprite2D.flip_h = 0
		$AnimatedSprite2D.animation = 'front'
	else:
		$AnimatedSprite2D.animation = 'side'
		$AnimatedSprite2D.flip_h = direction.x >= 0
	
	velocity = direction * SPEED
	if (!is_in_range): return;
	move_and_slide()

func animate_damage():
	$AnimatedSprite2D.self_modulate.s = 0.01
	$AnimatedSprite2D.self_modulate.h = 0.01
	await create_tween().tween_property($AnimatedSprite2D, "self_modulate:s", 1, 0.1).finished
	create_tween().tween_property($AnimatedSprite2D, "self_modulate:s", 0, 0.1)
	$AnimatedSprite2D.self_modulate.s = 0.0

func hit(damage):
	life = life - damage
	animate_damage()
	$Hurt.play()
	if life <= 0.0:
		await $Hurt.finished
		queue_free()

func _on_damage_timer_timeout():
	player.mental_hit(damage)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player.mental_hit(damage)
		$DamageTimer.start()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$DamageTimer.stop()
