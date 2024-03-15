extends Node2D

export(int) var x_value
export(int) var y_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when a body enters the Area2D.
func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		body.set_position(Vector2(x_value, y_value))
