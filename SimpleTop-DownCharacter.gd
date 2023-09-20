# Created: 09/19/2023
# Author : Corbin Meier
# Description:
#	Provides basic character movement. The character can move in all directions
#	with WASD keys. Not affected by Physics Bodies, but affects Physics Bodies.
extends CharacterBody2D

const SPEED = 100.0

func _physics_process(_delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x = Input.get_axis("left", "right")
	var dir_y = Input.get_axis("up", "down")
	var normalize = Vector2(dir_x, dir_y).normalized()
	velocity = normalize * SPEED
	move_and_slide()
	
	# Get Mouse Position relative to player
	var mouse_position = get_viewport().get_mouse_position()
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	var relativeDirection = Vector2(mouse_position.y - screen_height / 2, -(mouse_position.x - screen_width / 2))
	# Rotate the player towards the mouse
	var angle_to_mouse = relativeDirection.angle()
	rotation = angle_to_mouse
