extends KinematicBody2D

export(NodePath) var targetNodePath # Path to the object to track
var target = null # Reference to the target object
var health = 12 # Health of the enemy
var isAttacking = false # Flag to indicate if the enemy is attacking
var velocity = Vector2.ZERO # Velocity of the enemy
var gravity = 2000 # Gravity applied to the enemy
var maxSpeed = 150 # Maximum speed of the enemy
var acceleration = 500 # Acceleration of the enemy
var attackRange = 150 # Range at which the enemy attacks
var attackCooldown = 1 # Cooldown between attacks in seconds
var attackCooldownTimer = 0 # Timer for attack cooldown
var attackDamage = 1 # Damage dealt by the enemy per attack
var animSprite = null # Reference to the animated sprite node
var jumpPower = -800 # Power of the jump
var collisionShape = null # Reference to the collision shape
var attackInterrupted = false
var emitted = false

# Signal emitted when the enemy dies
signal died

func _ready():
	# Get reference to the target object
	if targetNodePath != null:
		target = get_node(targetNodePath)

	# Get reference to the animated sprite node
	animSprite = $AnimatedSprite
	collisionShape = $enemy_attack/CollisionShape2D
	collisionShape.set_deferred("disabled", true)

func _process(delta):
	if target != null:
		# Calculate distance to the target
		var distance = position.distance_to(target.position)

		# Check if the target is within attack range
		if distance < attackRange:
			if not isAttacking and attackCooldownTimer <= 0:
				# Attack the target
				attack()
				yield(get_tree().create_timer(0.5), "timeout")
				if !attackInterrupted:
					$enemy_attack/CollisionShape2D.set_deferred("disabled", false)
				attackInterrupted = false
				yield(get_tree().create_timer(0.5), "timeout")
				$enemy_attack/CollisionShape2D.set_deferred("disabled", true)
		else:
			# Move towards the target if not attacking
			$enemy_attack/CollisionShape2D.set_deferred("disabled", true)
			if not isAttacking:
				move_towards(target.position, delta)

		# Update attack cooldown timer
		if attackCooldownTimer > 0:
			attackCooldownTimer -= delta
		else:
			# Ensure we're not stuck in attacking mode when the player is out of range
			isAttacking = false

	# Apply gravity
	velocity.y += gravity * delta

	# Limit vertical speed to prevent falling too fast
	velocity.y = clamp(velocity.y, -1000, 1000)

	# Move the enemy
	move_and_slide(velocity, Vector2.UP)

func move_towards(target_position, delta):
	# Calculate velocity towards the target
	var direction = (target_position - position).normalized()
	velocity.x = move_towards_value(velocity.x, direction.x * maxSpeed, acceleration * delta)

	# Flip sprite based on movement direction
	if velocity.x < 0:
		animSprite.flip_h = true
	elif velocity.x > 0:
		animSprite.flip_h = false

	# Play walking animation
	animSprite.play("walking")

func move_towards_value(current, target, max_change):
	if current < target:
		return min(current + max_change, target)
	elif current > target:
		return max(current - max_change, target)
	else:
		return current

func attack():
	# Play attack animation
	animSprite.play("attack")
	isAttacking = true
	velocity.x = 0 # Stop moving during attack

	# Reset attack cooldown timer
	attackCooldownTimer = attackCooldown

func apply_damage(damage):
	# Reduce enemy's health
	health -= damage

	# Check if enemy is attacking and interrupt attack if necessary
	if isAttacking:
		isAttacking = false
		attackInterrupted = true

	# Check if enemy is dead
	if health <= 0:
		die()
	else:
		# Play hurt animation
		animSprite.play("hurt")
		isAttacking = false

func die():
	# Play death animation
	animSprite.play("dead")

	# Disable collision
	set_collision_layer_bit(0, false)
	$CollisionShape2D.set_deferred("disabled", true)
	# Disable enemy
	set_process(false)

	# Emit the 'died' signal
	if !emitted:
		emit_signal("died")
		emitted = true

func _input(event):
	if event.is_action_pressed("ui_up"):
		# Check if the enemy is on the ground before jumping
		if is_on_floor():
			jump()

func jump():
	velocity.y = jumpPower

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.name == "attack_1" or area.name == "attack_2":
		apply_damage(1)

func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		isAttacking = false
		collisionShape.set_deferred("disabled", true)
