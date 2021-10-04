extends "res://Scripts/CarBaseScript.gd"


var wheel_front_left
var wheel_front_right

func _ready():
	wheel_front_left = get_node("wheel_front_left")
	wheel_front_right = get_node("wheel_front_right")


func get_input():
	var turn = Input.get_action_strength("steer_left")
	turn -= Input.get_action_strength("steer_right")
	steer_angle = turn * deg2rad(steering_limit)
	wheel_front_right.rotation.z = steer_angle*4
	wheel_front_left.rotation.z = steer_angle*4
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = -transform.basis.z * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = -transform.basis.z * braking
