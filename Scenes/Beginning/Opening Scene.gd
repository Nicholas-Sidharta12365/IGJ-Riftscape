extends Node2D

var animated_sprite : AnimatedSprite

func _ready() -> void:
	# Assuming AnimatedSprite node is named "AnimatedSprite"
	animated_sprite = $AnimatedSprite
	animated_sprite.visible = false
	Global.current_map = "res://Scenes/Beginning/Opening Scene.tscn"

	$RectAnimationPlayer.play("Fade In")
	yield(get_tree().create_timer(6), "timeout")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Enemy" and animated_sprite.animation != "appear":
		animated_sprite.visible = true
		animated_sprite.play("appear")
		# Connect the animation_finished signal to a method
		animated_sprite.connect("animation_finished", self, "_on_appear_animation_finished")
		$AnimatedSprite/Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_appear_animation_finished():
	# Change to the idle animation when "appear" animation is finished
	animated_sprite.play("idle")
