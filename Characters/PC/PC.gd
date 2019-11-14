extends Actor

var health = 100
var can_take_object = false
var object_resource = null
var object_taken = false
var cooldown_time = 0.2
var can_jump = true

func _ready():
	Events.connect("damage_inflicted", self, "damage_character")
	Events.connect("grab_entered", self, "_on_grab_toggle", [ true ])
	Events.connect("grab_exited", self, "_on_grab_toggle", [ false ])

func _on_grab_toggle (resource, new_value):
	object_resource = resource
	can_take_object = new_value
	print (new_value)

func _physics_process(delta):
	if can_take_object and Input.is_action_just_pressed("jump"):
		$GrabbingHand.take_object(object_resource)
		return
	if Input.is_action_just_pressed("Fire"):
		if can_take_object == false:
			$GrabbingHand.throw_object()
	if not can_jump:
		can_jump = Input.is_action_just_released("jump")
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	$Health.value = health
	var direction: = get_direction()
	
	_velocity = calculate_move_velocity(
		_velocity,
		direction,
		speed,
		is_jump_interrupted
	)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0 and can_jump:
		can_jump = false
		new_velocity.y = speed.y * direction.y
	elif _velocity.y > 0.0:
		new_velocity.y = 1300.0
	if is_jump_interrupted:
		can_jump = true
		new_velocity.y = 1300.0 + _velocity.y
	return new_velocity

func damage_character():
	if health != 0:
		health -= 10
	else:
		print('ya estoy muerto, que dolor')

func has_object():
	return $GrabbingHand.object_taken

func recover_object(object_node):
	$GrabbingHand.recover_object(object_node)
