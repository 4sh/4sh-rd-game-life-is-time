extends CharacterBody2D

const SPEED = 300.0
var sprite

func _ready():
	sprite = $PlayerSprite

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	if direction.length() > 0:
		if $Timer.is_stopped() == true:
			$AudioStreamPlayer2D.play()
			$Timer.start()
		sprite.animation = "walk"
		sprite.flip_h = velocity.x < 0
		sprite.play()
	else:
		$Timer.stop()
		sprite.animation = "idle"
		sprite.stop()
	
	move_and_slide()


func _on_worlds_can_toggle_world():
	pass # Replace with function body.


func _on_timer_timeout():
	$AudioStreamPlayer2D.play()
