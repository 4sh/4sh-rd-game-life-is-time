extends Node2D

signal can_toggle_world
signal toggled_world

@onready var light_world = $Light
@onready var dark_world = $Dark
var player: Node2D


enum World { DARK, LIGHT }

var world = World.LIGHT

func world_map(w):
	return w.get_node("Map")

func _ready():
	player = get_tree().get_first_node_in_group("player")
	light_world.visible = true # during edit, often set to invisible for easy editing
	dark_world.visible = true # during edit, often set to invisible for easy editing
	remove_child(dark_world)

func has_tile(w, layer):
	return has_map_tile(w.get_node("Map"), layer) or has_map_tile(w.get_node("Map2"), layer)

func has_map_tile(map, layer):
	if map == null || player == null || player.position == null: return false
	var target_map_pos = map.local_to_map(map.to_local(player.position))
	return map.get_cell_tile_data(layer, target_map_pos) != null

func _process(delta):
	var target_world
		
	if world == World.LIGHT:
		target_world = World.DARK
	elif world == World.DARK:
		target_world = World.LIGHT		
	
	var new_world: Node2D;
	var old_world: Node2D;
	if (target_world == World.DARK):
		old_world = light_world
		new_world = dark_world
	else:
		old_world = dark_world
		new_world = light_world
			
	var can_toggle = has_tile(new_world, 1) and !has_tile(new_world, 2) and !has_tile(new_world, 3) and !has_tile(new_world, 4)

	can_toggle_world.emit(can_toggle)
	get_tree().get_first_node_in_group("hud").on_worlds_can_toggle_world(can_toggle, target_world == World.DARK)
			
	if (Input.is_action_just_pressed("toggle_dark_world")):
		print(can_toggle)
		
	if (can_toggle && Input.is_action_just_pressed("toggle_dark_world")):
		remove_child(old_world)
		add_child(new_world)
		world = target_world
		toggled_world.emit(target_world == World.DARK)
		get_tree().get_first_node_in_group("player")._on_worlds_toggled_world(target_world == World.DARK)
			
