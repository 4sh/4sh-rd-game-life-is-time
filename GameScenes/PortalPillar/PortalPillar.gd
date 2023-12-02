extends Node2D

signal player_entered_active_portal

@export var spot_portal_zoom = 2.0
var active: bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_camera: Camera2D = player.get_node("Camera2D")

func _ready():
	$Camera2D.zoom = Vector2(spot_portal_zoom, spot_portal_zoom)
	$CanvasLayer/SpotPortal.transform.scaled($Camera2D.zoom * 1.25)
	$Sprite2D.modulate.v = 0.5
	$CanvasLayer/SpotPortal.modulate.a = 1.0
	$CanvasLayer.hide()

func activate():
	if (active): return
	player.invulnerable = true
	get_tree().call_group("hud", "clear_dialog")
	$CanvasLayer/Hide.modulate.a = 0
	$CanvasLayer/SpotPortal.hide()
	$CanvasLayer.show()
	await create_tween().tween_property($CanvasLayer/Hide, "modulate:a", 1.0, 0.5).finished
	$CanvasLayer/SpotPortal.show()
	$Camera2D.enabled = true
	$Camera2D.make_current()
	active = true
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property($CanvasLayer/Hide, "modulate:a", 0.0, 0.5)
	tween.tween_interval(0.5)
	tween.tween_property($Sprite2D, "modulate:v", 1.0, 0.25)
	tween.tween_property($Sprite2D, "modulate:v", 0.0, 0.25)
	tween.tween_property($Sprite2D, "modulate:v", 1.0, 0.5)
	tween.tween_interval(0.5)
	tween.tween_property($CanvasLayer/Hide, "modulate:a", 1.0, 0.5)
	tween.tween_interval(0.5)
	tween.tween_callback($CanvasLayer/SpotPortal.hide)
	tween.tween_callback(player_camera.make_current)
	tween.tween_property($CanvasLayer/Hide, "modulate:a", 0.0, 0.5)
	tween.tween_callback($CanvasLayer.hide)	
	tween.tween_callback(func(): player.invulnerable = false)


func _on_area_2d_body_entered(body):
	if active and body.is_in_group("player"):
		player_entered_active_portal.emit()
