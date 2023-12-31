extends Area2D

@export var SPEED = 50.0
@export var damage = 10
@export var max_distance = 100

@onready var player = get_tree().get_first_node_in_group("player") 

func _ready():
	$AnimatedSprite2D.animation = 'front'
	$AnimatedSprite2D.play()

func get_player_pos():
	return player.position

func _process(delta):
	var player_pos: Vector2 = get_player_pos()
	var direction = (player_pos - position)
	if (direction.length > max_distance): return;
	
	direction = direction.normalized()
	if abs(direction.y) > abs(direction.x):
		$AnimatedSprite2D.animation = 'front'
	else:
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = 0
			$AnimatedSprite2D.animation = 'side'
		else:
			$AnimatedSprite2D.flip_h = 1
			$AnimatedSprite2D.animation = 'side'
	
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		player.hit(10)
		$DamageTimer.start()

func _on_damage_timer_timeout():
	player.hit(10)

func _on_body_exited(body):
	if body.is_in_group("player"):
		$DamageTimer.stop()
