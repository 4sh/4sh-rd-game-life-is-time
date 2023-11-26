extends CharacterBody2D


@export var speed = 80.0
@export var life = 100.0
@export var mental_health = 100.0
@export var mental_damage_on_move_to_dark = 10.0
@export var attack_damage = 10.0
@export var attack_length = 10.0
@export var can_attack:bool = false

signal life_changed(life)
signal mental_health_changed(mental_health)
signal dead


@onready var sprite = $PlayerSprite

@onready var sounds = {
	"hurt": preload('res://Assets/Sounds/Trivia/Hurt.wav'),
	"heal": preload('res://Assets/Sounds/Trivia/Drink.wav')
}

var heal_animate = false
var mental_heal_animate = false
var invulnerable = false
var paused = false
var last_direction = Vector2(0,1)


func play_sound(sound):
	$AudioStreamPlayer2D.stream = sounds[sound]
	$AudioStreamPlayer2D.play()

func _ready():
	life_changed.emit(life)
	mental_health_changed.emit(mental_health)
	$Sword.attack_damage = attack_damage
	$Sword.attack_length = attack_length

func get_direction_label_suffix(direction: Vector2):
	var d = direction.normalized()
	if (d.y < 0 && abs(d.y) > abs(d.x)):
		return "_top"
	if (d.x < 0 && abs(d.x) >= abs(d.y)):
		return "_left"
	if (d.x > 0 && abs(d.x) >= abs(d.y)):
		return "_right"
	return "_front"

func _physics_process(delta):
	if (paused): return
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if direction.length() > 0:
		if $FootstepsTimer.is_stopped() == true:
			$Footsteps.play()
			$FootstepsTimer.start()
		last_direction = direction
		sprite.animation = "walk" + get_direction_label_suffix(direction)
		sprite.play()
	else:
		$FootstepsTimer.stop()
		sprite.animation = "idle" + get_direction_label_suffix(last_direction)
		sprite.stop()
		
	move_and_slide()

func _process(delta):
	if can_attack and Input.is_action_just_pressed("attack"):
		$Sword.attack(last_direction)

func animate_damage():
	$PlayerSprite.self_modulate.s = 0.01
	$PlayerSprite.self_modulate.h = 0.01
	await create_tween().tween_property($PlayerSprite, "self_modulate:s", 1, 0.1).finished
	create_tween().tween_property($PlayerSprite, "self_modulate:s", 0, 0.1)
	$PlayerSprite.self_modulate.s = 0.0

func animate_heal():
	$PlayerSprite.self_modulate.s = 0.01
	$PlayerSprite.self_modulate.h = 0.14
	await create_tween().tween_property($PlayerSprite, "self_modulate:s", 1, 0.3).finished
	create_tween().tween_property($PlayerSprite, "self_modulate:s", 0, 0.1)
	$PlayerSprite.self_modulate.s = 0.0

func hit(damage):
	if (invulnerable): return
	invulnerable = true
	animate_damage()
	play_sound("hurt")
	life = life - damage
	life_changed.emit(life)
	$InvulnerabilityTimer.start()
	if (life <= 0):
		dead.emit()

func mental_hit(damage):
	animate_damage()
	mental_health = mental_health - damage
	mental_health_changed.emit(mental_health)
	if (mental_health <= 0):
		dead.emit()

func heal(heal):
	invulnerable = true
	animate_heal()
	play_sound("heal")
	life = clamp(life + heal, 0, 100)
	life_changed.emit(life)
	$InvulnerabilityTimer.start()

func mental_heal(heal):
	animate_heal()
	mental_health = clamp(mental_health + heal, 0, 100)
	mental_health_changed.emit(mental_health)

func _on_worlds_toggled_world(moved_to_dark):
	if (moved_to_dark):
		mental_hit(mental_damage_on_move_to_dark)
	life = clamp(100 - life, 5, 100)
	life_changed.emit(life)

func _on_invulnerability_timer_timeout():
	invulnerable = false


func _on_footsteps_timer_timeout():
	$Footsteps.play()
