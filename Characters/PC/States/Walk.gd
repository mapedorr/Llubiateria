extends "res://Main/StateMachine/State.gd"

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to(owner.STATES.JUMP)
	
	if owner.is_on_floor() and event.is_action_pressed("grab"):
		_state_machine.transition_to(owner.STATES.GRAB)
		
	elif event.is_action_pressed("Fire"):
		_state_machine.transition_to(owner.STATES.THROW)


func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		if _parent.velocity.y > 0.0:
			_state_machine.transition_to("Move/Fall")
	
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	owner.play_animation(owner.STATES.WALK, _state_machine._previous_state)


func exit() -> void:
	.exit()
	owner.stop_animation(owner.STATES.WALK)

