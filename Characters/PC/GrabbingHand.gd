extends Node2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
var current_resource
var current_object
var current_level
var current_dir
var first_grab = true
var using_hand = false
var object_taken = false


""" ════ Funciones ═════════════════════════════════════════════════════════ """
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../")

func _on_object_collided(current_pos):
	if first_grab == false and using_hand == false:
		self.remove_child(current_object)
		current_level.add_child(current_object)
		current_object.set_owner(current_level)

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
		add_child(current_object)
		
		first_grab = false
		using_hand = true
		object_taken = true
		Events.emit_signal("object_taken")
		if current_object.get_name() == "Battery":
			get_node("../Audio/BatteryGrab").play()
		else:
			get_node("../Audio/Grab").play()

func throw_object():
	get_node("../Audio/Throw").play()
	if object_taken:
		current_object.throw_object(current_dir)
		remove_child(current_object)
		current_level.add_child(current_object)
		current_object.set_owner(current_level)
		using_hand = false
		object_taken = false

func recover_object(object_node):
	var object_resource = object_node.my_resource
	object_node.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	current_object = null
	take_object(object_resource)