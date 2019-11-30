extends "res://Main/StateMachine/State.gd"

export var boost: = Vector2(2.0, 0.0)

var is_jump_interrupted: = false

func unhandled_input(event: InputEvent) -> void:
	is_jump_interrupted = event.is_action_released("jump") and _parent.velocity.y < 0.0


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	if is_jump_interrupted:
		_state_machine.transition_to("Move/Fall", { "jump_interrupted": true })
	elif _parent.velocity.y > 0.0:
		if not owner.is_on_floor():
			_state_machine.transition_to("Move/Fall", { "jump_interrupted": false })


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)

	is_jump_interrupted = false
	if msg.has("safe_jump"):
		# Poner la velocidad en Y a 0.0 para que se eleve el PC cuando se ha
		# saltado justo después de dejar una plataforma
		_parent.velocity.y = 0.0
	_parent.velocity += calculate_jump_velocity()
	
	owner.play_animation(owner.ANIMS.JUMP)


func exit() -> void:
	.exit()


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
