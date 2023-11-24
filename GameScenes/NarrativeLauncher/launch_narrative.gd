extends Area2D

@export var narrationIndex: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group('player'):
		get_tree().get_first_node_in_group("hud").on_narration_launched(narrationIndex)
