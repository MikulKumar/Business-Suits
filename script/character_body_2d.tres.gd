extends CharacterBody2D

# Movement constants
const SPEED = 150.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

# Reference to sprite
@onready var sprite = $AnimatedSprite2D

# State variables
var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME
	
	# Handle jump buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	# Jump input
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	# Execute jump if conditions are met
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0
	
	# Variable jump height (release jump button early for shorter jump)
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5
	
	# Get horizontal input
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Apply acceleration or friction
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		
		# Flip sprite based on direction
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	move_and_slide()
