extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("cycle")


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Scenes/Intro/Intro.tscn")
