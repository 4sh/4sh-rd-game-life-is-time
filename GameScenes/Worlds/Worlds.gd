extends Node2D

signal can_toggle_world
signal toggled_world

@onready var light_world = $Light
@onready var dark_world = $Dark
var player: CharacterBody2D


enum World { DARK, LIGHT }

var world = World.LIGHT
@onready var viewport = get_viewport()
@onready var dark_view:SubViewportContainer = get_node("../%DarkWorldView")
@onready var light_view:SubViewportContainer = get_node("../%LightWorldView")


func _ready():
	player = get_tree().get_first_node_in_group("player")
	light_world.visible = true # during edit, often set to invisible for easy editing
	dark_world.visible = true # during edit, often set to invisible for easy editing
	viewport.canvas_cull_mask &= ~dark_world.visibility_layer
	viewport.canvas_cull_mask &= ~light_world.visibility_layer
	dark_view.visible = false
	var winsize = get_viewport_rect().size
	dark_view.get_node("SubViewport").size = winsize
	light_view.get_node("SubViewport").size = winsize
	player.visibility_layer = light_world.visibility_layer



func can_go_to(new_world, position):
	return has_tile(new_world, position)

func has_tile(w, position):
	var has_tile = false
	var map = w.get_node("Map")
	for layer in range(0,4):
		has_tile = has_tile || has_map_tile(map, layer, position)
	return has_tile

func has_map_tile(map, layer, position):
	if map == null: return false
	var target_map_pos = map.local_to_map(map.to_local(position))
	var tile_data = map.get_cell_tile_data(layer, target_map_pos)
	return tile_data != null && tile_data.get_collision_polygons_count(0) == 0

func _process(delta):
	var target_world
	var origin_collision_layer
	var target_collision_layer
		
	if world == World.LIGHT:
		target_world = World.DARK
		origin_collision_layer = 1
		target_collision_layer = 32
	elif world == World.DARK:
		target_world = World.LIGHT		
		origin_collision_layer = 32
		target_collision_layer = 1
	
	var new_world: Node2D;
	var old_world: Node2D;
	var new_world_view;
	var old_world_view;
	if (target_world == World.DARK):
		old_world = light_world
		new_world = dark_world
		old_world_view = light_view
		new_world_view = dark_view
	else:
		old_world = dark_world
		new_world = light_world
		old_world_view = dark_view
		new_world_view = light_view
			
	var can_toggle = can_go_to(new_world, player.position)

	can_toggle_world.emit(can_toggle)
	get_tree().get_first_node_in_group("hud").on_worlds_can_toggle_world(can_toggle, target_world == World.DARK)
	get_tree().get_first_node_in_group("player").on_worlds_can_toggle_world(can_toggle, target_world == World.DARK)
			
	if (can_toggle && Input.is_action_just_pressed("toggle_dark_world")):
		var player = get_tree().get_first_node_in_group("player")
		new_world_view.modulate.a = 0
		new_world_view.show()
		player.collision_mask |= target_collision_layer
		
		create_tween().tween_property(new_world_view, "modulate:a", 1.0, 1.0)
		create_tween().tween_property(old_world_view, "modulate:a", 0.0, 1.0)
		
		create_tween().tween_property(old_world_view.get_node("SubViewport/Camera2D"), "zoom", Vector2(2,2), 0.5)
		await create_tween().tween_property(new_world_view.get_node("SubViewport/Camera2D"), "zoom", Vector2(2,2), 0.5).finished
		player.collision_mask &= ~origin_collision_layer
		player.visibility_layer = new_world.visibility_layer
		create_tween().tween_property(old_world_view.get_node("SubViewport/Camera2D"), "zoom", Vector2(4,4), 0.5)
		await create_tween().tween_property(new_world_view.get_node("SubViewport/Camera2D"), "zoom", Vector2(4,4), 0.5).finished
		
		old_world_view.hide()
		old_world_view.modulate.a = 1
		get_tree().get_first_node_in_group("hud")._on_worlds_toggled_world(target_world == World.DARK)
		player._on_worlds_toggled_world(target_world == World.DARK)
		world = target_world
		toggled_world.emit(target_world == World.DARK)
			
