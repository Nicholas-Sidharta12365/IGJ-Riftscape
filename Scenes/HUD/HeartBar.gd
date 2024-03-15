extends HBoxContainer

enum MODES {simple, empty}

var heart_full = preload("res://Assets/Hearts/PNG/basic/heart.png")
var heart_empty = preload("res://Assets/Hearts/PNG/basic/border.png")

export (MODES) var mode = MODES.simple

func _ready():
	# Connect to the player's health_changed signal
	Global.connect("health_changed", self, "_on_player_health_changed")
	update_health(Global.player_health)

func update_health(health_value):
	match mode:
		MODES.simple:
			update_simple(health_value)
		MODES.empty:
			update_empty(health_value)
			
func update_simple(health_value):
	for i in range(get_child_count()):
		get_child(i).visible = health_value > i
		
func update_empty(health_value):
	for i in range(get_child_count()):
		if health_value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

func _on_player_health_changed(health_value):
	# Handle player health change here
	update_health(health_value)
