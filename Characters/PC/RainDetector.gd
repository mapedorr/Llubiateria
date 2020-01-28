extends Sprite

""" ════ Variables ═════════════════════════════════════════════════════════ """
var dflt_pos: Vector2 = Vector2.ZERO
var dir: = 0

onready var init_pos: Vector2 = position
""" ════ Funciones ═════════════════════════════════════════════════════════ """
func _ready() -> void:
	update_dflt_pos()


func update_dflt_pos():
	dir = -1 if is_flipped_h() else 1
	dflt_pos = position


func flip(x_dir: int):
	set_flip_h(x_dir < 0)
	set_position(Vector2(init_pos.x * x_dir, init_pos.y))
	update_dflt_pos()


func place(x: int = 0, y: int = 0, dflt_x: bool = false, dflt_y: bool = false):
	x *= get_scale().abs().x
	y *= get_scale().abs().y

	if dflt_x and dflt_y:
		position = dflt_pos
	else:
		if y != 0: position.y = dflt_pos.y + y
		elif dflt_y: position.y = dflt_pos.y
		if x != 0: position.x = dflt_pos.x + x * dir
		elif dflt_x: position.x = dflt_pos.x
