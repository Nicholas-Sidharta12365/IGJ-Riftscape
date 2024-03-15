extends Particles2D

export(String) var node_player

# Reference to the player node
var player_node = null
# Offset to position the particle above the player
var offset = Vector2(0, -480)  # Adjust the Y value to your desired offset

func _ready():
	player_node = get_parent().get_node(node_player)

func _process(delta):
	if player_node:
		# Check if the player is grounded (you'll need to replace "is_on_floor()" 
		# with your actual ground detection logic)
		var is_grounded = player_node.is_on_floor()

		# If the player is grounded, set the position of the particle above the player's position
		if is_grounded:
			position = player_node.global_position + offset
