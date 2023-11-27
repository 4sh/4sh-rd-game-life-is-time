extends Node2D

const BLOB = preload("res://GameScenes/Blob/blob.tscn")
@export var nb_blobs:int = 5
@export var blobs_speed:int = 30
@export var blobs_life:int = 20
@export var blobs_max_distance:int = 50


func _ready():
	for n in nb_blobs:
		var blob = BLOB.instantiate()
		blob.position = $Player.position + Vector2(100, n*20)
		blob.max_distance = blobs_max_distance
		blob.speed = blobs_speed
		blob.life = blobs_life
		add_child(blob)

func _process(delta):
	pass
