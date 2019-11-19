extends "res://Main/StateMachine/State.gd"
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""

export var speed: = Vector2(300.0, 1200.0)
export var jump_impulse: = 900.0

var _velocity: = Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Jump")

#	if owner.can_take_object and event.is_action_pressed("jump"):
#		owner.take_object()
#		# TODO: disparar la animación de recoger objeto
#		return
	
#	if not owner.can_jump:
#		owner.can_jump = Input.is_action_released("jump")
	
#	if event.is_action_pressed("Fire"):
#		if owner.can_take_object == false:
#			owner.throw_object()


func physics_process(delta: float) -> void:
#	if can_take_object and Input.is_action_pressed("jump"):
#		$GrabbingHand.take_object(object_resource)
#		return
#	if Input.is_action_pressed("Fire"):
#		if can_take_object == false:
#			$GrabbingHand.throw_object()
#	if not can_jump:
#		can_jump = Input.is_action_released("jump")
#	var is_jump_interrupted = Input.is_action_released("jump") and _velocity.y < 0.0
#	$Health.value = health
	var direction: = get_move_direction()
	
	
#	if not direction.x  == 0:
#		walking = true
#		if is_on_floor():
#			if walking:
#				if can_play:
#					$Walk.play()
#					can_play = false
#		$GrabbingHand.current_dir = Vector2(direction.x, -1.0)
#		$Sprite.set_flip_h(direction.x < 0)
#	else:
#		if can_play == false and is_on_floor():
#			$Stop.play()
#			walking = false
#
#		$Walk.stop()
#		can_play = true
	
	_velocity = calculate_move_velocity(
		_velocity,
		direction,
		speed
	)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)

#	_fall_time += delta
#
#	if Input.is_action_pressed("jump"):
#		if direction.y == -1.0:
#			$Walk.stop()
#			$Jump.play()


func enter(msg: Dictionary = {}) -> void:
	# TODO: conectar señales
	pass


func exit() -> void:
	# TODO: desconectar señales
	pass

"""
Funciones propias de este estado.
"""

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)

static func calculate_move_velocity(
		old_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var new_velocity = old_velocity

	new_velocity.x = speed.x * direction.x
#	new_velocity.x *= boost.x if not is_on_floor() else 1.0
#	new_velocity.y += gravity * get_physics_process_delta_time()

#	if direction.y == -1.0 and can_jump:
#		can_jump = false
#		new_velocity.y = speed.y * direction.y
#	elif _velocity.y > 0.0:
#		new_velocity.y = 1300.0
#	if is_jump_interrupted:
#		can_jump = true
#		new_velocity.y = 1300.0 + _velocity.y
	return new_velocity
