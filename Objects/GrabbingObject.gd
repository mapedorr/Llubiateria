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
var can_take = true
var my_resource

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../../")
	$Pickable.connect("body_entered", self, "_on_body_entered")
	$Pickable.connect("body_exited", self, "_on_body_exited")
#	connect("tree_entered", self, "_on_tree_entered")

func _process(delta):
	if object_thrown:
		move_and_slide(Vector2 (200,200), Vector2(0,-10))

func grab_object(position):
	can_take = false
	original_pos = position
	set_position(original_pos)

func _on_body_entered(other):
	print(other.get_name())
	if other.get_name() == "PC":
		current_pos = get_global_position()
		if object_thrown == true and can_take and not other.has_object():
			$Pickable.disconnect("body_entered", self, "_on_body_entered")
			$Pickable.disconnect("body_exited", self, "_on_body_exited")
			other.recover_object(self)

func _on_body_exited(other):
	if other.get_name() == "PC":
		yield(get_tree().create_timer(0.5), "timeout")
		can_take = true
#		Events.emit_signal("object_collided", current_pos)

func _on_tree_entered():
	can_take = true