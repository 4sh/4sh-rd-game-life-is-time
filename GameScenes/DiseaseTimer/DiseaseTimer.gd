extends Timer

@export var damage:int = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_timeout():
	var p = get_tree().get_first_node_in_group("player")
	if p:
		p.hit(damage)
