extends CharacterBody2D


@export var speed = 5000.0
@export var life = 100.0
@export var mental_health = 100.0

signal life_changed(life)
signal mental_health_changed(mental_health)
signal dead


@onready var sprite = $PlayerSprite

var heal_animate = false
var mental_heal_animate = false

func _ready():
	life_changed.emit(life)
	mental_health_changed.emit(mental_health)


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed * delta
	if direction.length() > 0:
		sprite.animation = "walk"
		sprite.flip_h = velocity.x < 0
		sprite.play()
	else:
		sprite.animation = "idle"
		sprite.stop()
		
	move_and_slide()

func animate_damage():
	$PlayerSprite.self_modulate.s = 0.01
	$PlayerSprite.self_modulate.h = 0.01
	await create_tween().tween_property($PlayerSprite, "self_modulate:s", 1, 0.1).finished
	create_tween().tween_property($PlayerSprite, "self_modulate:s", 0, 0.1)
	$PlayerSprite.self_modulate.s = 0.0

func animate_heal():
	$PlayerSprite.self_modulate.s = 0.01
	$PlayerSprite.self_modulate.h = 0.15
	await create_tween().tween_property($PlayerSprite, "self_modulate:s", 1, 0.2).finished
	create_tween().tween_property($PlayerSprite, "self_modulate:s", 0, 0.1)
	$PlayerSprite.self_modulate.s = 0.0

func hit(damage):
	animate_damage()
	life = life - damage
	life_changed.emit(life)
	if (life <= 0):
		dead.emit()

func mental_hit(damage):
	animate_damage()
	mental_health = mental_health - damage
	mental_health_changed.emit(mental_health)
	if (mental_health <= 0):
		dead.emit()

func heal(heal):
	animate_heal()
	life = life + heal
	clamp(life, 0, 100)
	life_changed.emit(life)

func mental_heal(heal):
	animate_heal()
	mental_health = mental_health + heal
	clamp(mental_health, 0, 100)
	mental_health_changed.emit(mental_health)
