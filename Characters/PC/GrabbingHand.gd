extends Node2D

var current_resource
var current_object
var current_level
var current_dir
var first_grab = true
var using_hand = false
var object_taken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../")

func _on_object_collided(current_pos):
	if first_grab == false and using_hand == false:
		self.remove_child(current_object)
		current_level.add_child(current_object)
		current_object.set_owner(current_level)

func take_object(object_resource):
	current_resource = object_resource
	if not object_taken:
		current_object = object_resource.instance()
		add_child(current_object)
		current_object.grab_object($GrabLocation.get_position())
		current_object.my_resource = object_resource
		first_grab = false
		using_hand = true
		Events.emit_signal("object_taken")
		object_taken = true
		if current_object.get_name() == "Battery":
			get_node("../BatteryGrab").play()
		else:
			get_node("../Grab").play()

func throw_object():
	get_node("../Throw").play()
	if object_taken:
		current_object.throw_object(current_dir)
		current_object.set_position($GrabLocation.get_global_position())
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