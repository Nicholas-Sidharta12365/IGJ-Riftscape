extends Node2D

export(String) var target_body_name = "" # Variable to store the target body name
export(NodePath) var target_player_path = "" # Variable to store the path to the player node

var animation_playing = false

func _ready() -> void:
	$Area2D.connect("body_entered", self, '_play_animation')
	$AnimationPlayer.connect("animation_started", self, "_on_animation_started")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	
func _play_animation(body):
	if body.name == target_body_name and not animation_playing:
		$AnimationPlayer.play("generate")
		animation_playing = true

func _on_animation_started(anim_name):
	if anim_name == "generate":
		# Disable player input or movement controls
		var player = get_node(target_player_path)
		if player:
			player.disable_controls()

func _on_animation_finished(anim_name):
	if anim_name == "generate":
		# Enable player input or movement controls
		var player = get_node(target_player_path)
		if player:
			player.enable_controls()
		animation_playing = false
		# Disconnect the signal to prevent further calls to _play_animation
		$Area2D.disconnect("body_entered", self, '_play_animation')
