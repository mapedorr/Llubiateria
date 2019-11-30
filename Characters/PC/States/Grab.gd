extends "res://Main/StateMachine/State.gd"
"""
Controla el estado que permite al jugador agarrar objetos del suelo para cargarlos
o eventualmente lanzarlos.
"""

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	.unhandled_input(event)


func physics_process(delta: float) -> void:
	.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	owner.take()
	# TODO: disparar la animación de agarrar algo, poner un yield para esperar
	# a que termine y sólo entonces cambie al estado idle
	_state_machine.transition_to("Move/Idle")


func exit() -> void:
	.exit()