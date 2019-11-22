extends "res://Main/StateMachine/State.gd"

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Walk"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	if msg.has("jump_interrupted") and msg.jump_interrupted:
		_parent.velocity.y += 1300.0
	else:
		_parent.velocity.y = 1300.0


func exit() -> void:
	_parent.exit()