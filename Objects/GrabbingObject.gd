extends KinematicBody2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
const FLOOR_NORMAL: = Vector2.UP

export var initial_speed: = Vector2(500, -500)
export var elasticity := 0.5
export var gravity := 30.0
export var friction := 10.0

var _velocity: = Vector2.ZERO 
var object_thrown = false
export var free_movement := false

var original_pos = Vector2()
var current_level
var current_pos
var can_take = true
var my_resource
var direction = Vector2()


""" ════ Funciones ═════════════════════════════════════════════════════════ """
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = get_node("../../../")
	$Pickable.connect("body_entered", self, "_on_body_entered")
	$Pickable.connect("body_exited", self, "_on_body_exited")
#	connect("tree_entered", self, "_on_tree_entered")


func _physics_process(delta):
	if object_thrown:
		if !free_movement:
			free_movement = true
			_velocity.x = direction.x * initial_speed.x
			_velocity.y = initial_speed.y
		
		if is_on_wall():
			_velocity.x = -_velocity.x

		if is_on_floor():
			if _velocity.x >= -10 && _velocity.x <= 10:
				_velocity.x = 0
			else:
				_velocity.x = (_velocity.x - friction) if _velocity.x > 0 else _velocity.x + friction
				_velocity.y = -_velocity.y * elasticity
			
		if is_on_ceiling():
			_velocity.y = -_velocity.y
		
		
		_velocity.y = _velocity.y + gravity
		
		direction = move_and_slide(_velocity, FLOOR_NORMAL)


func initialize(props):
	can_take = false
	original_pos = props.position
	my_resource = props.resource
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
		# Events.emit_signal("object_collided", current_pos)


func _on_tree_entered():
	can_take = true