tool

extends Area2D

export(String, FILE) var next_scene_path = ""
export(Vector2) var player_spawn_location = Vector2.ZERO
export(String) var character_name = ""

func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "next_scene_path needed"
	else:
		return ""

func _on_Next_Map_body_entered(body: Node) -> void:
	if body.name == character_name:
		Global.player_initial_map_position = player_spawn_location
		get_tree().change_scene(next_scene_path)
