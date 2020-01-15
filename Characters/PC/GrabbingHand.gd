extends Node2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
var current_resource
var current_object
var current_level
var current_dir
var first_grab = true
var object_taken = false

""" ════ Funciones ═════════════════════════════════════════════════════════ """
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../")

func take_object(object_resource):
	if not object_resource: return
	current_resource = object_resource
	
	if not object_taken:
		# Crear el objeto e inicializarlo
		current_object = object_resource.instance()
		current_object.initialize({
			"position": $GrabLocation.get_position(),
			"resource": object_resource
		})
		current_object.picker = self
		current_object.set_picked(true)
		
		if current_object.get_name() == "Battery":
			get_node("../Audio/BatteryGrab").play()
		else:
			get_node("../Audio/Grab").play()
			
		if first_grab:
			add_child(current_object)
			first_grab = false
			
func throw_object():
	get_node("../Audio/Throw").play()