extends Node2D


func _on_area_2d_body_entered(body):
	if (body.is_in_group("player")):
		$TileMap/PortalPillar.activate()


func _on_portal_pillar_player_entered_active_portal():
	get_tree().quit()
