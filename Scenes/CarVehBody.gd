extends VehicleBody



var horse_power = 200
var accel_speed = 20
var steer_angle = deg2rad(30)
var steer_speed = 3
var brake_power = 40
var brake_speed = 40

func _physics_process(delta):
	var throttle_input = -Input.get_action_strength("accelerate") + Input.get_action_strength("brake")
	engine_force = lerp(engine_force,throttle_input*horse_power, accel_speed*delta)
	
	var steer_input = -Input.get_action_strength("steer_right")+Input.get_action_strength("steer_left")
	steering = lerp_angle(steering,steer_input*steer_angle, steer_speed*delta)
	
	var brake_input = Input.get_action_strength("brake")
	brake = lerp(brake,brake_input*brake_power, brake_speed*delta)
