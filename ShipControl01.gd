# Created: 09/18/2023
# Author : Corbin Meier
# Description:
#	Provides basic W - Forward, S Backward, A - Turn Left, and D - Turn Right movement.
#	Also has an option to control dampen settings with the Z key.
extends RigidBody2D

var linear_acceleration = 100.0 # Units/sec^2
var deceleration = 80.0 # Units/sec^2
var max_speed = 400.0 # Maximum speed in units/sec
var angular_acceleration = 4.0 # Angular acceleration in radians/sec^2
var angular_deceleration = 2.0 # Angular deceleration in radians/sec^2
var max_angular_speed = 2.0 # Maximum angular speed in radians/sec

var dampeners_active = false # Boolean flag for dampeners

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Toggle dampeners with 'D' key
	if Input.is_action_just_pressed("dampeners_toggle"):
		dampeners_active = not dampeners_active

	# Handle rotation
	var angular_input = 0.0
	if Input.is_action_pressed("left"):
		angular_input = -1.0
	elif Input.is_action_pressed("right"):
		angular_input = 1.0
	
	var new_angular_velocity = angular_velocity + angular_acceleration * angular_input * delta
	
	# Apply angular deceleration when no input is given and dampeners are active
	if angular_input == 0 and dampeners_active:
		var angular_deceleration_factor = sign(angular_velocity) * -1.0
		new_angular_velocity += angular_deceleration * angular_deceleration_factor * delta
	
	# Cap angular velocity to max angular speed
	if abs(new_angular_velocity) > max_angular_speed:
		new_angular_velocity = max_angular_speed * sign(new_angular_velocity)
	
	self.angular_velocity = new_angular_velocity
	
	# Handle linear acceleration and deceleration
	var forward_direction = Vector2(0, -1).rotated(rotation)
	var input_direction = 0.0
	if Input.is_action_pressed("up"):
		input_direction = 1.0
	elif Input.is_action_pressed("down"):
		input_direction = -1.0
	
	var acceleration_vector = forward_direction * linear_acceleration * input_direction
	
	# Calculate new linear velocity
	var new_velocity = linear_velocity
	if input_direction != 0:
		new_velocity += acceleration_vector * delta
	elif dampeners_active:
		var deceleration_vector = -linear_velocity.normalized() * deceleration
		new_velocity += deceleration_vector * delta
	
	# Cap linear velocity to max speed
	if new_velocity.length() > max_speed:
		new_velocity = new_velocity.normalized() * max_speed
	
	self.linear_velocity = new_velocity
