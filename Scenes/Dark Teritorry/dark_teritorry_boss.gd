extends Node2D

var dead_signal_count := 0

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		$container/CollisionShape2D.set_deferred("disabled", true)

func _on_dead():
	dead_signal_count += 1
	if dead_signal_count == 2: # 2 nodes emitting 2 signals each
		$second_wave/Area2D/CollisionShape2D.set_deferred("disabled", false)
		yield(get_tree().create_timer(7.5), "timeout")
		# Hide the boss node
		$Boss.hide()
		# Set position of Player2
		yield(get_tree().create_timer(0.5), "timeout")
		var player2 = $Player2
		player2.show()
		player2.position.x = 800
		player2.position.y = 406
		Global.boss_defeated_signal_received = true

func _ready():
	Global.current_map = "res://Scenes/Dark Teritorry/dark_teritorry_boss.tscn"
	$Nightborne.connect("died", self, "_on_dead")
	$Nightborne2.connect("died", self, "_on_dead")
	$Player2.hide()
	$second_wave/Area2D/CollisionShape2D.set_deferred("disabled", true)
