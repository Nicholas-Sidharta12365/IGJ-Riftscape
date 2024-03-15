extends KinematicBody2D

const GRAVITY = 800
const MOVE_SPEED = 200
const JUMP_FORCE = -500
const ATTACK_DURATION = 0.5 # Adjust the duration as needed

var velocity = Vector2()
var is_attacking = false

enum Direction { Right, Left }
var facing_direction = Direction.Left

enum State { Idle, Running, Jumping, Falling, Attacking }
var state = State.Idle

var animated_sprite: AnimatedSprite
var attack_timer: Timer

var controls_enabled = true

export var initial_position: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initial_position == Vector2(0, 0):
		self.global_position = Global.player_initial_map_position
	else:
		self.global_position = initial_position
	animated_sprite = $AnimatedSprite
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.connect("timeout", self, "_on_attack_timer_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_attacking:
		process_movement(delta)
	update_animation()

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
			animated_sprite.play("sprint")
		State.Jumping:
			animated_sprite.play("jump_start")
		State.Falling:
			animated_sprite.play("jump_end")
		State.Attacking:
			animated_sprite.play("attack")
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

# Function to disable player controls
func disable_controls() -> void:
	controls_enabled = false
	velocity = Vector2() # Stop player movement when controls are disabled
	state = State.Idle # Set player state to idle
	update_animation()

# Function to enable player controls
func enable_controls() -> void:
	controls_enabled = true
