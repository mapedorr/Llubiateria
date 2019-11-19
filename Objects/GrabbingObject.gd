extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(300.0, 1000.0)
export var weight: = 3000.0

var _velocity: = Vector2.ZERO 

var object_thrown = false
var original_pos = Vector2()
var current_level
var current_pos
var can_take = true
var my_resource
var direction = Vector2()
var bounce = Vector2()
var v_bounce = 200
var h_bounce = 300
var bounce_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../../")
	$Pickable.connect("body_entered", self, "_on_body_entered")
	$Pickable.connect("body_exited", self, "_on_body_exited")
#	connect("tree_entered", self, "_on_tree_entered")

func _physics_process(delta):
	if object_thrown:
		if _velocity.y < 0.0:
			direction.y = 1.0
		_velocity = calculate_move_velocity(_velocity, direction, speed)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		var collision = move_and_collide(direction * delta)
		if collision:
			direction = direction.bounce(collision.normal)
		if is_on_floor():
			bounce_num += 1
			if bounce_num == 4:
				direction.x = 0
				direction.y = 0
		if is_on_wall():
			direction.x = 0
		if is_on_ceiling():
			direction.x = 0
			direction.y = 1.0

func grab_object(position):
	bounce_num = 0
	can_take = false
	original_pos = position
	set_position(original_pos)

func throw_object(dir):
	direction = dir
	object_thrown = true
	

func _on_body_entered(other):
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

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += weight * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity