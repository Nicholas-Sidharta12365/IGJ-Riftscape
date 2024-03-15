extends Node2D

func _ready() -> void:
	Global.player_initial_map_position = Vector2(50, 510)
	Global.current_map = "res://Scenes/Starting Village/starting village_1.tscn"
	if Global.background_music == null:
		Global.start_background_music()
	$RectAnimationPlayer.play("Fade In")
	yield(get_tree().create_timer(6), "timeout")
