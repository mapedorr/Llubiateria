extends "res://Main/StateMachine/State.gd"

export var boost: = Vector2(2.0, 0.0)

var is_jump_interrupted: = false

func unhandled_input(event: InputEvent) -> void:
	is_jump_interrupted = event.is_action_released("jump") and _parent.velocity.y < 0.0


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	if is_jump_interrupted:
		_state_machine.transition_to("Move/Fall", { "jump_interrupted": true })
	elif not owner.is_on_floor():
		if _parent.velocity.y > 0.0:
			_state_machine.transition_to("Move/Fall", { "jump_interrupted": false })


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	is_jump_interrupted = false
	_parent.velocity += calculate_jump_velocity()


func exit() -> void:
	_parent.exit()


"""
Returns a new velocity with a vertical impulse applied to it
"""
func calculate_jump_velocity() -> Vector2:
	return _parent.calculate_move_velocity(
		_parent.velocity,
		Vector2.UP,
		_parent.speed,
		1.0,
		1.0
	)
