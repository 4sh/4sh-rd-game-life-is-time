extends Node2D

signal player_entered_active_portal

const default_camera_zoom = Vector2(3.0, 3.0)
const camera_to_spot_zoom_ratio = 1.25
@export var spot_portal_zoom = 1.5
var active: bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_camera: Camera2D = player.get_node("Camera2D")

func _ready():
	$Camera2D.zoom = default_camera_zoom
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
	var target_camera_zoom = Vector2(spot_portal_zoom, spot_portal_zoom)
	var target_spot_portal_transform = $CanvasLayer/SpotPortal.transform.scaled(target_camera_zoom * camera_to_spot_zoom_ratio)
	var tween = create_tween()
	tween.tween_interval(0.25)
	tween.tween_property($CanvasLayer/Hide, "modulate:a", 0.0, 0.5)
	tween.tween_interval(0.25)
	tween.tween_property($Sprite2D, "modulate:v", 1.0, 0.25)
	tween.tween_property($Sprite2D, "modulate:v", 0.0, 0.25)
	tween.tween_property($Sprite2D, "modulate:v", 1.0, 0.5)
	tween.tween_property($Camera2D, "zoom", target_camera_zoom, 0.5)
	tween.parallel().tween_property($CanvasLayer/Hide, "modulate:a", 1.0, 0.75)
	tween.tween_interval(0.25)
	tween.tween_callback($CanvasLayer/SpotPortal.hide)
	tween.tween_callback(player_camera.make_current)
	tween.tween_property($CanvasLayer/Hide, "modulate:a", 0.0, 0.5)
	tween.tween_callback($CanvasLayer.hide)	
	tween.tween_callback(
		func(): 
			player.invulnerable = false
			$Camera2D.zoom = default_camera_zoom
	)



func _on_area_2d_body_entered(body):
	if active and body.is_in_group("player"):
		player_entered_active_portal.emit()
