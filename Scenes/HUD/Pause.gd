extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_Resume_pressed() -> void:
	self.is_paused = false

func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Save_pressed() -> void:
	var file = File.new()
	file.open("./savegame.dat", File.WRITE)
	if file and file.open("./savegame.dat", File.WRITE) == OK:
		file.store_var(Global.player_health)
		file.store_var(Global.current_map)
		file.store_var(Global.is_dark)
		file.close()
		print("Game saved successfully.")

func _on_Load_pressed() -> void:
	var file = File.new()
	if file.open("./savegame.dat", File.READ) == OK:
		Global.player_health = file.get_var()
		Global.current_map = file.get_var()
		Global.is_dark = file.get_var()
		if Global.is_dark:
			Global.start_dark_music()
		else:
			Global.start_background_music()
		file.close()
		get_tree().paused = false
		get_tree().change_scene(Global.current_map)
		print("Game loaded successfully.")
	else:
		print("No save file found.")
