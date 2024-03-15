extends Control

func _on_Title_pressed() -> void:
	get_tree().change_scene("res://Scenes/Intro/Intro.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit()
