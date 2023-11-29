extends Area2D

@export var attack_damage = 10.0
@export var attack_length = 10.0:
	set (value):
		attack_length = value
		$Collision.scale = Vector2(1,1) * attack_length / default_length
	

@onready var sounds = {
	"sword_slash": preload('res://Assets/Sounds/bruit attaque 1.wav')
}

const default_length = 20.0
var can_attack = true

func put_away():
	hide()
	$Collision.set_deferred("disabled", true)

func use():
	show()
	$Collision.set_deferred("disabled", false)
		
func _ready():
	$Collision.scale = Vector2(1,1) * attack_length / default_length
	put_away()

func play_sound(sound):
	$AudioPlayer.stream = sounds[sound]
	$AudioPlayer.play()

func play_sword_animation():
	use()
	$Sprite.play()
	await $Sprite.animation_finished
	$Sprite.stop()
	put_away()
	
func damage_enemy(enemy):
	if enemy.is_in_group("enemy"):
		enemy.hit(attack_damage, (enemy.position - $'..'.position).normalized())

func _on_body_entered(body):
	damage_enemy(body)

func attack(direction: Vector2):
	if (!can_attack): return
	can_attack = false
	rotation = direction.angle() + PI/2
	play_sound("sword_slash")
	await play_sword_animation()
	$WaitBetweenAttacksTimer.start()


func _on_wait_between_attacks_timer_timeout():
	can_attack = true
