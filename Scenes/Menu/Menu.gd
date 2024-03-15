extends Node2D

var sprite

func _ready():
	sprite = $Sprite 
	set_process_input(true)

func _input(event):

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and !get_tree().paused:
		var mouse_position = get_global_mouse_position()
		if sprite.get_rect().has_point(mouse_position):
			change_scene()

func change_scene():
	var next_scene = "res://Scenes/Beginning/Opening Scene.tscn"
	if next_scene:
		get_tree().change_scene(next_scene) 
