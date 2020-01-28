extends TextureProgress
""" ════ Variables ═════════════════════════════════════════════════════════ """
var dflt_pos: Vector2 = Vector2.ZERO
var dir: = 0

onready var init_scale: Vector2 = get_scale()
onready var init_pos: Vector2 = rect_position
""" ════ Funciones ═════════════════════════════════════════════════════════ """
func _ready() -> void:
	update_dflt_pos()


func update_dflt_pos():
#	set_scale
	dir = -1 if is_flipped() else 1
	dflt_pos = rect_position


func flip(x_dir: int):
	set_scale(Vector2(init_scale.x * x_dir, init_scale.y))
	set_position(Vector2(init_pos.x * x_dir, init_pos.y))
	update_dflt_pos()


func is_flipped():
	return get_scale().x < 0


func place(x: int = 0, y: int = 0, dflt_x: bool = false, dflt_y: bool = false):
	x *= get_scale().abs().x
	y *= get_scale().abs().y

	if dflt_x and dflt_y:
		rect_position = dflt_pos
	else:
		if y != 0: rect_position.y = dflt_pos.y + y
		elif dflt_y: rect_position.y = dflt_pos.y
		if x != 0: rect_position.x = dflt_pos.x + x * dir
		elif dflt_x: rect_position.x = dflt_pos.x
