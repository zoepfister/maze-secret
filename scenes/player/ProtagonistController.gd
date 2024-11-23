extends CharacterBody2D
class_name Player

@onready var player_camera: Camera2D = $PlayerCamera

@export var acceleration = 1500  # Acceleration in pixels per second squared
@export var max_speed = 300     # Maximum speed in pixels per second
@export var friction = INF     # Deceleration when not moving in pixels per second squared= 300;

var has_torch : bool = false
var animation_suffix : String = ""

func _physics_process(delta: float) -> void:
	$PointLight2D.enabled = has_torch
	# Get input direction
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	player_camera = $PlayerCamera
	player_camera.make_current()

 # Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply acceleration
	if direction != Vector2.ZERO:
		# Accelerate in input direction, scaled by delta time
		velocity += direction * acceleration * delta
		# Clamp to max speed
		velocity = velocity.limit_length(max_speed)
	else:
		# Apply friction when no input
		var friction_amount = friction * delta
		if velocity.length() > friction_amount:
			velocity -= velocity.normalized() * friction_amount
		else:
			# If remaining velocity is less than friction amount, stop completely
			velocity = Vector2.ZERO
	move_and_slide()
	
	#
	if has_torch : animation_suffix = "_torch"
	else: animation_suffix = ""
	
	if direction != Vector2.ZERO:
		# Character is moving
		if direction.x == 1:
			$AnimatedSprite2D.play("walk_right_down"+animation_suffix)
		# Flip sprite based on movement direction
		if direction.x == -1:
			$AnimatedSprite2D.play("walk_left_down"+animation_suffix)
			
		if direction.y == 1:
			$AnimatedSprite2D.play("walk_down"+animation_suffix)
		if direction.y == -1:
			$AnimatedSprite2D.play("walk_up"+animation_suffix)
	else:
		# Character is idle
		$AnimatedSprite2D.play("idle"+animation_suffix)
