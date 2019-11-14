extends KinematicBody2D

export (int) var object_gravity = 5
export (int) var object_speed = 5
export (float) var object_angle = 350

var _gravity = 10
var _movement = Vector2()
var object_thrown = false
var directional_force = Vector2()
var original_pos = Vector2()
var current_level
var current_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../../")
	$Pickable.connect("body_entered", self, "_on_body_entered")
	$Pickable.connect("body_exited", self, "_on_body_exited")
	connect("tree_entered", self, "_on_tree_entered")

func _process(delta):
	if object_thrown:
		move_and_slide(Vector2 (200,200), Vector2(0,-10))

func grab_object(position):
	original_pos = position
	set_position(original_pos)

func throw_object(pos):
	object_thrown = true
	set_global_position(pos)
	original_pos = pos

func _on_body_entered(other):
	if other.get_name() == "PC":
		if object_thrown == true:
			grab_object(original_pos)
			other.take_object()
			.queue_free()
		other.object_taken = true
		current_pos = get_global_position()
	

func _on_body_exited(other):
	if other.get_name() == "PC":
		Events.emit_signal("object_collided", current_pos)
		

func _on_tree_entered():
	if object_thrown:
		set_position(to_global(current_pos))




