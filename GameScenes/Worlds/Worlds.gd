extends Node2D

signal can_toggle_world
signal toggled_world

@onready var light_world = $Light
@onready var dark_world = $Dark
@export var player: Node2D


enum World { DARK, LIGHT }

var world = World.LIGHT

func world_map(world):
	return world.get_node("Map")

func _ready():
	light_world.visible = true # during edit, often set to invisible for easy editing
	dark_world.visible = true # during edit, often set to invisible for easy editing
	remove_child(dark_world)


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
			
	var target_map = world_map(new_world)
	var target_map_pos = target_map.local_to_map(target_map.to_local(player.position))
	var tile_data: TileData = target_map.get_cell_tile_data(1, target_map_pos)
	
	var can_toggle = tile_data != null

	can_toggle_world.emit(can_toggle)
	get_tree().get_first_node_in_group("hud").on_worlds_can_toggle_world(can_toggle, target_world == World.DARK)
				
	if (can_toggle && Input.is_action_just_pressed("toggle_dark_world")):
		remove_child(old_world)
		add_child(new_world)
		world = target_world
		toggled_world.emit(target_world == World.DARK)
		get_tree().get_first_node_in_group("player")._on_worlds_toggled_world(target_world == World.DARK)
			