extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP
const FALL_JUMP_TIME: = 0.09

export var speed: = Vector2(300.0, 1200.0)
export var gravity: = 3000.0
export var boost: = Vector2.ZERO

var _velocity: = Vector2.ZERO
var _fall_time: = 0.0
