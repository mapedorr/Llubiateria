extends Node
class_name State
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `_parent.physics_process(delta)`
Use State as a child of a StateMachine node.
"""


onready var _state_machine: = _get_state_machine(self)
onready var _owner: PC = (owner as PC)
var _parent: State = null


func _ready() -> void:
	yield(owner, "ready")
	_parent = get_parent()


func unhandled_input(event: InputEvent) -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func enter(msg: Dictionary = {}) -> void:
	"""print(">>> " + name)"""
	pass


func exit() -> void:
	"""print(name + " >>>")"""
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
