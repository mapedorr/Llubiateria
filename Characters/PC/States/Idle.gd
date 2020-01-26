extends "res://Main/StateMachine/State.gd"

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to(owner.STATES.JUMP)
	
	if owner.is_on_floor() and event.is_action_pressed("grab"):
		_state_machine.transition_to(owner.STATES.GRAB)
		
	elif event.is_action_pressed("throw") and owner.object_taken:
		_state_machine.transition_to(owner.STATES.THROW)


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to(owner.STATES.WALK)
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	
	_parent.velocity = Vector2.ZERO
	
	owner.play_animation(owner.STATES.IDLE, _state_machine._previous_state)


func exit() -> void:
	.exit()
	owner.stop_animation(owner.STATES.IDLE)

