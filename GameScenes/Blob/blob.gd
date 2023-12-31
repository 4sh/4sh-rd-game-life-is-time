extends CharacterBody2D

@export var speed = 30.0
@export var damage = 10
@export var max_distance = 50
@export var life = 20.0
@export var moved_by_hit_speed = 50.0
@export var move_by_hit_timeframe = 0.2

@export var show_hurt_labels:bool = false

@onready var player = get_tree().get_first_node_in_group("player") 

var hurt_labels = []
var projection_by_hit_vector: Vector2
var move_by_hit: bool

func _ready():
	$AnimatedSprite2D.animation = 'front'
	$AnimatedSprite2D.play()
	$HurtLabelNode2D.hide()


func get_player_pos():
	return player.position

func _process(delta):
	var direction = Vector2.ZERO
	if (move_by_hit):
		direction = projection_by_hit_vector
		velocity = direction * moved_by_hit_speed
	else:
		var player_pos: Vector2 = get_player_pos()
		direction = (player_pos - position)
		var is_in_range = direction.length() < max_distance
		direction = direction.normalized()
		
		if abs(direction.y) > abs(direction.x):
			$AnimatedSprite2D.flip_h = 0
			$AnimatedSprite2D.animation = 'front'
		else:
			$AnimatedSprite2D.animation = 'side'
			$AnimatedSprite2D.flip_h = direction.x >= 0
		
		if (!is_in_range): return;
		velocity = direction * speed
	move_and_slide()

func animate_damage():
	$AnimatedSprite2D.self_modulate.s = 0.01
	$AnimatedSprite2D.self_modulate.h = 0.01
	await create_tween().tween_property($AnimatedSprite2D, "self_modulate:s", 1, 0.1).finished
	create_tween().tween_property($AnimatedSprite2D, "self_modulate:s", 0, 0.1)
	$AnimatedSprite2D.self_modulate.s = 0.0

func hit(damage, displacement_vector):
	life = life - damage
	animate_damage()
	$Hurt.play()
	if displacement_vector != null:
		activate_movement(displacement_vector)
	if show_hurt_labels:
		hurt_labels.push_front("- " + str(damage))
		$HurtLabelNode2D/HurtLabel.text = hurt_labels.reduce(func(accum, str): return accum + "\n" + str, "")
		$HurtLabelNode2D.show()
	if life <= 0.0:
		await $Hurt.finished
		queue_free()
	await get_tree().create_timer(1.5).timeout
	if show_hurt_labels:
		hurt_labels.pop_back()
		if (hurt_labels.size() == 0):
			$HurtLabelNode2D.hide()
			$HurtLabelNode2D/HurtLabel.text = ""
		else:
			$HurtLabelNode2D/HurtLabel.text = hurt_labels.reduce(func(accum, str): return accum + "\n" + str, "")

func activate_movement(displacement_vector):
	move_by_hit = true
	projection_by_hit_vector = displacement_vector
	get_tree().create_timer(move_by_hit_timeframe).timeout.connect(func(): move_by_hit = false)

func _on_damage_timer_timeout():
	player.mental_hit(damage)

func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		player.mental_hit(damage)
		$DamageTimer.start() # repeat attacks as long as the player has not exited

func _on_attack_body_exited(body):
	if body.is_in_group("player"):
		$DamageTimer.stop()
