extends TextureProgress

onready var init_scale: Vector2 = get_scale()
onready var init_pos: Vector2 = rect_position
var dflt_pos: Vector2 = Vector2.ZERO
var dir: = 0

func _ready() -> void:
	update_dflt_pos()


func update_dflt_pos():
#	set_scale
	dir = -1 if is_flipped() else 1
	dflt_pos = rect_position


func flip(x_dir: int):
	set_scale(Vector2(init_scale.x * x_dir, init_scale.y))
	var new_x_pos: float = init_pos.x * x_dir
	if x_dir < 0:
		new_x_pos *= 2
	set_position(Vector2(new_x_pos, init_pos.y))
	update_dflt_pos()


func is_flipped():
	return get_scale().x < 0


""" ──── Funciones para coordinar con animación IDLE ─────────────────────── """
func idle_0():
	rect_position = dflt_pos


func idle_1():
	rect_position.y = dflt_pos.y + 4


func idle_2():
	rect_position.x = dflt_pos.x + 4 * dir


func idle_3():
	rect_position.y = dflt_pos.y
""" ──────────────────────────────────────────────────────────────────────── """