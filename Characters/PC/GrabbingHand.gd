extends Node2D

var current_object
var current_level
var first_grab = true
var using_hand = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../")
	Events.connect("object_collided", self, "_on_object_collided")
	

func throw():
	current_object.throw_object(current_object.get_global_position())
	using_hand = false
	
	

func _on_object_collided(current_pos):
	print('me estan tocando')
	if first_grab == false and using_hand == false:
		self.remove_child(current_object)
		current_level.add_child(current_object)
		current_object.set_owner(current_level)
	