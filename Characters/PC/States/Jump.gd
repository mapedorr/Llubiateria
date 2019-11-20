extends "res://Main/StateMachine/State.gd"
"""
Manages Air movement, including jumping and landing.
You can pass a msg to this state, every key is optional:
{
	velocity: Vector2, to preserve inertia from the previous state
	impulse: float, to make the character jump
	wall_jump: bool, to take air control off the player for controls_freeze.wait_time seconds upon entering the state
}
The player can jump after falling off a ledge. See unhandled_input and jump_delay.
"""

export var boost: = Vector2(2.0, 0.0)

func unhandled_input(event: InputEvent) -> void:
	# Jump after falling off a ledge
	if event.is_action_pressed("jump"):
		if _parent.velocity.y >= 0.0:
            # _parent.velocity = calculate_jump_velocity(_parent.jump_impulse)
            pass
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Walk"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
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
		1.0
	)
