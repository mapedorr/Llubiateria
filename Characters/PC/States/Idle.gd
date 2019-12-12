extends "res://Main/StateMachine/State.gd"

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		if not owner.can_take_object:
			_state_machine.transition_to("Move/Jump")
		else:
			_state_machine.transition_to("Grab")
	elif event.is_action_pressed("Fire"):
		_state_machine.transition_to("Throw")


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Walk")
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	
	_parent.velocity = Vector2.ZERO
	
	owner.play_animation(owner.ANIMS.IDLE, _state_machine._previous_state)


func exit() -> void:
	.exit()
	owner.stop_animation(owner.ANIMS.IDLE)

