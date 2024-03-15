extends Area2D

var portal: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal = $"../AnimatedSprite/Area2D/CollisionShape2D"
	portal.set_deferred("disabled", true)


func _on_Teleport_area_entered(area: Area2D) -> void:
	if area.name == "attack_1" or area.name == "attack_2":
		portal.set_deferred("disabled", false)
