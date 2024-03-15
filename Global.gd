extends Node
signal health_changed(health_value)

var player_initial_map_position = Vector2(50, 510)
var background_music: AudioStreamPlayer = null
var player_health = 6
var boss_defeated_signal_received = false
var current_map = ""
var is_dark = false

func _ready():
	# Connect the signal to a function
	connect("health_changed", self, "_on_health_changed")

# Define the function to handle the signal
func _on_health_changed(health_value):
	# You can also assign it to the player_health variable if needed
	player_health = health_value
	
	if player_health <= 0 and boss_defeated_signal_received:
		stop_background_music()
		get_tree().change_scene("res://Scenes/Ending/ending.tscn")
	
	elif player_health <= 0:
		stop_background_music()
		get_tree().change_scene("res://Scenes/Game Over/game over.tscn")

# Function to start the background music
func start_background_music():
	# Load the background music if it's not already loaded
	if background_music == null:
		background_music = AudioStreamPlayer.new()
		var music = preload("res://Assets/Music/investigating-the-mystery.ogg")
		background_music.stream = music
		add_child(background_music)
		is_dark = false
	# Start playing the background music
	background_music.play()

# Function to stop the background music
func stop_background_music():
	if background_music != null:
		background_music.stop()
		background_music = null

func start_dark_music():
	if background_music == null:
		background_music = AudioStreamPlayer.new()
		var music_dark = preload("res://Assets/Music/anti-hero.ogg")
		background_music.stream = music_dark
		add_child(background_music)
		is_dark = true
		
	background_music.play()
