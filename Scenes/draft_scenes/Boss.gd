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
@onready var worlds = get_node("../%Worlds")
@onready var boss_view = get_node("../BossView")
@onready var boss_viewport = get_node("../%BossViewport")
@onready var nav_agent = $NavigationAgent2D

var switching_in_progress = false
var wait_before_next_switch = false

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
	boss_viewport.world_2d = get_viewport().world_2d
	$PortalSprite.hide()
	go_to_light()

func _physics_process(delta):
	if switching_in_progress:
		return	
	
	if !is_player_in_same_world():
		boss_view.show()
	else:
		boss_view.hide()

	if !is_player_in_same_world() && !wait_before_next_switch && can_switch_world():
		switch_world()
		return
	
	var direction = to_local(nav_agent.get_next_path_position()).normalized()		
	velocity = direction * speed
	var collided = move_and_slide()
	var distance_to_player = (global_position - player.global_position).length()
	if collided && distance_to_player > 10 && !wait_before_next_switch && can_switch_world():
		switch_world()
	
	boss_viewport.get_node("Camera2D").position = position

func switch_world():
	switching_in_progress = true
	wait_before_next_switch = true

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
	await get_tree().create_timer(2).timeout
	wait_before_next_switch = false

func make_path():
	nav_agent.target_position = player.global_position

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
	
func _on_timer_timeout():
	make_path()
