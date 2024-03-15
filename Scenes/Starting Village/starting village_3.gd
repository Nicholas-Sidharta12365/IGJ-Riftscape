extends Node2D

var animated_sprite

func _ready() -> void:
	Global.player_initial_map_position = Vector2(50, 510)
	Global.current_map = "res://Scenes/Starting Village/starting village_3.tscn"
	animated_sprite = $AnimatedSprite
	animated_sprite.visible = false
	$teleport_dark/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedText2/Area2D/CollisionShape2D.set_deferred("disabled", true)
	$RectAnimationPlayer.play("Fade In")
	yield(get_tree().create_timer(6), "timeout")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player" and animated_sprite.animation != "appear":
		animated_sprite.visible = true
		animated_sprite.play("appear")
		# Connect the animation_finished signal to a method
		animated_sprite.connect("animation_finished", self, "_on_appear_animation_finished")
		$teleport_dark/CollisionShape2D.set_deferred("disabled", false)
		$AnimatedText2/Area2D/CollisionShape2D.set_deferred("disabled", false)

func _on_appear_animation_finished():
	# Change to the idle animation when "appear" animation is finished
	animated_sprite.play("idle")
