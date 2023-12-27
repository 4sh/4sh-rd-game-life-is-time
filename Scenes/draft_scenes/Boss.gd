extends CharacterBody2D

@export var speed = 10.0
@export var max_distance = 500

@onready var player = get_tree().get_first_node_in_group("player") 

const light_collision_layer = 1
const dark_collision_layer = 32
const light_visibility_layer = 2
const dark_visibility_layer = 32

@onready var dark = %Dark
@onready var light = %Light
@onready var portal = $PortalSprite
@onready var worlds = get_parent().get_node("%Worlds")

var switching_in_progress = false

func get_player_pos():
	return player.position

func is_player_in_light():
	return player.collision_mask & light_collision_layer

func is_in_light():
	return collision_mask & light_collision_layer

func is_player_in_same_world():
	return (player.collision_mask & light_collision_layer) && (collision_mask & light_collision_layer) || (player.collision_mask & dark_collision_layer) && (collision_mask & dark_collision_layer)

func can_switch_world():
	var target_world
	if (is_in_light()):
		target_world = dark
	else:
		target_world = light
	
	return worlds.can_go_to(target_world, position)

func _ready():
	$PortalSprite.hide()
	go_to_light()

func _process(delta):
	if switching_in_progress:
		return	

	if !is_player_in_same_world() && can_switch_world():
		switch_world()
		return
			
	var direction = Vector2.ZERO
	var player_pos: Vector2 = get_player_pos()
	direction = (player_pos - position)
	var is_in_range = direction.length() < max_distance
	direction = direction.normalized()
		
	if (!is_in_range): return;
	velocity = direction * speed
	move_and_slide()

func switch_world():
	switching_in_progress = true

	if (is_player_in_light()):
		change_parent(portal, light)
	else:
		change_parent(portal, dark)

	if is_player_in_same_world():
		change_parent(self, get_parent()) # fix order
		
	portal.position = position
	portal.show()
	portal.play()
	await portal.animation_finished
	portal.stop()
	portal.hide()

	if (is_in_light()):
		go_to_dark()
	else:
		go_to_light()
	switching_in_progress = false
	

func go_to_dark():
	change_parent(self, dark)
	collision_mask &= ~light_collision_layer
	collision_mask |= dark_collision_layer
	$Sprite2D.visibility_layer &= ~light_visibility_layer
	$Sprite2D.visibility_layer |= dark_visibility_layer

func go_to_light():
	change_parent(self, light)
	collision_mask &= ~dark_collision_layer
	collision_mask |= light_collision_layer
	$Sprite2D.visibility_layer &= ~dark_visibility_layer
	$Sprite2D.visibility_layer |= light_visibility_layer

func change_parent(node, next_parent):
	node.get_parent().call_deferred("remove_child", node)
	next_parent.call_deferred("add_child", node)
	
