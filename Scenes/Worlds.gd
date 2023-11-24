extends Node2D


@onready var light_world = $Light
@onready var dark_world = $Dark

enum World { DARK, LIGHT }

var world = World.LIGHT

func _ready():
	light_world.visible = true # during edit, often set to invisible for easy editing
	dark_world.visible = true # during edit, often set to invisible for easy editing
	remove_child(dark_world)


func _process(delta):
	if Input.is_action_just_pressed("toggle_dark_world"):	
		
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
		
		var old_player: Node2D = old_world.player
		var new_player: Node2D = new_world.player
		
		var target_map_pos = new_world.map.local_to_map(old_player.position)
		var tile_data: TileData = new_world.map.get_cell_tile_data(1, target_map_pos)

			
		print(target_map_pos)
		print(tile_data)
		
		if (tile_data != null):
			remove_child(old_world)
			add_child(new_world)
			new_player.position = old_player.position
			world = target_world
			

