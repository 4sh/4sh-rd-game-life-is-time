extends SubViewportContainer

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	$SubViewport.world_2d = get_parent().get_viewport().world_2d

func _process(_delta):
	$SubViewport/Camera2D.position = player.position
