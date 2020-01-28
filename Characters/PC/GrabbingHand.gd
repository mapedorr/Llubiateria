extends Node2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
var current_resource
var current_object
var current_level
var current_dir: Vector2 = Vector2.RIGHT
var first_grab = true
var object_taken = false

""" ════ Funciones ═════════════════════════════════════════════════════════ """
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../")

			
func throw_object():
	get_node("../Audio/Throw").play()