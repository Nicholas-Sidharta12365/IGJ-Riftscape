extends KinematicBody2D

signal health_changed(new_health_value)

const GRAVITY = 800
const MOVE_SPEED = 200
const JUMP_FORCE = -500
const ATTACK_DURATION = 0.5 # Adjust the duration as needed

var velocity = Vector2()
var is_attacking = false

enum Direction { Right, Left }
var facing_direction = Direction.Right

enum State { Idle, Running, Jumping, Falling, Attacking }
var state = State.Idle

var animated_sprite: AnimatedSprite
var attack_timer: Timer

var controls_enabled = true

var max_hearts = 6
var current_hearts = Global.player_health

export(Vector2) var playerInitialMapPosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if playerInitialMapPosition != Vector2.ZERO:
		self.global_position = playerInitialMapPosition
	else:
		self.global_position = Global.player_initial_map_position
	$attack_1/attack_1_hitbox.set_deferred("disabled", true)
	$attack_2/attack_2_hitbox.set_deferred("disabled", true)
	animated_sprite = $AnimatedSprite
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.connect("timeout", self, "_on_attack_timer_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_attacking:
		process_input()
		process_movement(delta)
	update_animation()
	
	for body in $attack_1.get_overlapping_bodies():
		if body.name == "nightborne":
			print("HIT")

func process_input() -> void:
	if controls_enabled and !is_attacking:
		velocity.x = 0
		if Input.is_action_pressed("ui_right"):
			velocity.x += MOVE_SPEED
			facing_direction = Direction.Right
		elif Input.is_action_pressed("ui_left"):
			velocity.x -= MOVE_SPEED
			facing_direction = Direction.Left
		
		if is_on_floor() and Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			state = State.Jumping

		if Input.is_action_just_pressed("attack"):
			start_attack()

func process_movement(delta: float) -> void:
	if !is_attacking:
		velocity.y += GRAVITY * delta
		velocity = move_and_slide(velocity, Vector2.UP)

		if is_on_floor():
			if velocity.y > 0:
				state = State.Falling
			else:
				if velocity.x != 0:
					state = State.Running
				else:
					state = State.Idle
		else:
			if velocity.y < 0:
				state = State.Jumping
			else:
				state = State.Falling

func update_animation() -> void:
	match state:
		State.Idle:
			animated_sprite.play("idle")
		State.Running:
			animated_sprite.play("run")
		State.Jumping:
			animated_sprite.play("jump_start")
		State.Falling:
			animated_sprite.play("jump_end")
		State.Attacking:
			if facing_direction == Direction.Right:
				animated_sprite.play("attack_1")
				$attack_player.play("attack_1")
			else:
				animated_sprite.play("attack_2")
				$attack_player.play("attack_2")
	animated_sprite.flip_h = (facing_direction == Direction.Left)

func start_attack() -> void:
	is_attacking = true
	state = State.Attacking
	update_animation()
	attack_timer.start(ATTACK_DURATION)

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	state = State.Idle
	update_animation()

func refresh_hearts() -> void:
	Global.emit_signal("health_changed", current_hearts)

# Method to reduce player's health
func take_damage() -> void:
	current_hearts -= 1
	if current_hearts < 0:
		current_hearts = 0
	Global.emit_signal("health_changed", current_hearts)

# Method to restore player's health
func heal() -> void:
	current_hearts += 1
	if current_hearts > max_hearts:
		current_hearts = max_hearts
	Global.emit_signal("health_changed", current_hearts)

# Function to disable player controls
func disable_controls() -> void:
	controls_enabled = false
	velocity = Vector2() # Stop player movement when controls are disabled
	state = State.Idle # Set player state to idle
	update_animation()

# Function to enable player controls
func enable_controls() -> void:
	controls_enabled = true

func set_position(pos) -> void:
	self.position = pos


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "enemy_attack" or area.name == "attack_1_evil" or area.name == "attack_2_evil":
		take_damage()
