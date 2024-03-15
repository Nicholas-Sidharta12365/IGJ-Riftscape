extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the signal emitted by the enemy
	# Assuming you have a reference to the enemy node called 'enemy'
	$"Next Map/CollisionShape2D".set_deferred("disabled", true)
	Global.current_map = "res://Scenes/Dark Teritorry/dark_teritorry_low_1.tscn"
	if Global.background_music != null:
		Global.stop_background_music()
		Global.start_dark_music()
	$Nightborne.connect("died", self, "_on_enemy_died")

# Function called when the enemy dies
func _on_enemy_died() -> void:
	# Enable the collision shape
	$"Next Map/CollisionShape2D".set_deferred("disabled", false)
