extends "res://Main/StateMachine/State.gd"
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""

export var speed: = Vector2(300.0, 1200.0)

var velocity: = Vector2.ZERO
var gravity: = 3000.0
var is_jump_interrupted: = false

func unhandled_input(event: InputEvent) -> void:
	.unhandled_input(event)


func physics_process(delta: float) -> void:
	var direction = get_move_direction()
	velocity = calculate_move_velocity(
		velocity,
		direction,
		speed,
		delta
	)
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	
	# TODO: Quitar de aquí esta chambonada
	if not direction.x  == 0:
		owner.get_node("GrabbingHand").current_dir = Vector2(direction.x, -1.0)
		owner.get_node("Sprite").set_flip_h(direction.x < 0)


func enter(msg: Dictionary = {}) -> void:
	# TODO: conectar señales
	pass


func exit() -> void:
	# TODO: desconectar señales
	pass

"""
Funciones propias de este estado.
"""

func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)

func calculate_move_velocity(
		old_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		delta: float
	) -> Vector2:
	var new_velocity = old_velocity

	new_velocity += direction * delta
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * delta

	if direction.y == -1.0:
		new_velocity.y = speed.y * -1.0

	if old_velocity.y > 0.0:
		new_velocity.y = 1300.0
	
	if is_jump_interrupted:
		new_velocity.y = 1300.0 + old_velocity.y
	
	return new_velocity
