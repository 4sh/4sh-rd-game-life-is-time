extends CharacterBody2D


@export var speed = 300.0
@export var life = 100.0

signal life_changed(life)
signal dead


@onready var sprite = $PlayerSprite

func _ready():
	life_changed.emit(life)


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if direction.length() > 0:
		sprite.animation = "walk"
		sprite.flip_h = velocity.x < 0
		sprite.play()
	else:
		sprite.animation = "idle"
		sprite.stop()
		
	move_and_slide()


func hit(damage):
	life = life - damage
	life_changed.emit(life)
	if (life <= 0):
		dead.emit()

func heal(heal):
	life = life + heal
	clamp(life, 0, 100)
	life_changed.emit(life)
