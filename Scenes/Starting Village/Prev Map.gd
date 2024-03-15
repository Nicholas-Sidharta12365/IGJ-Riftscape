extends Area2D

func _on_Prev_Map_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_tree().change_scene("res://Scenes/Starting Village/starting village_1.tscn")
