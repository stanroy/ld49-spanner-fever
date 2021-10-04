extends Spatial


onready var ball = $SphereController
onready var car_area = $CarRoot
onready var car_mesh = $CarRoot/Car
onready var ground_ray = $CarRoot/RayCast
onready var camera = $Camera
onready var front_right_wheel = $CarRoot/wheel_front_right
onready var front_left_wheel = $CarRoot/wheel_front_left
onready var rear_right_wheel = $CarRoot/wheel_rear_right
onready var rear_left_wheel = $CarRoot/wheel_rear_left
onready var anim_player = $AnimationPlayer
onready var smoke_particles_back = $CarRoot/ShmokeParticlesBack/CPUParticles
onready var smoke_particles_front = $CarRoot/ShmokeParticlesFront/CPUParticles
onready var engine_audio_player = $AudioStreamPlayer
onready var car_explosion_player = $ExplosionSound
onready var engine_smoke_particles = $CarRoot/EngineShmokeParticles/CPUParticles
onready var car_explosion_particles = $CarRoot/ExplosionParticles

export (Material) var blown_car
export var sphere_offset = Vector3(0,-1.1,0)
export var acceleration = 50
export var steering = 21.0
export var turn_speed = 5
export var turn_stop_limit = 0.75

export var speed_input = 0
export var rotate_input = 0
export var body_tilt = 70
export var wheel_spin = 70


export var engine_pitch = 0.1
export var min_engine_pitch = 0.1
export var max_engine_pitch = 2.4


# Called when the node enters the scene tree for the first time.
func _ready():
	ground_ray.add_exception(ball)
	smoke_particles_back.emitting = false
	smoke_particles_front.emitting = false
	engine_audio_player.pitch_scale = engine_pitch
	
	
	
func _physics_process(delta):
	car_area.transform.origin = ball.transform.origin + sphere_offset
	ball.add_central_force(-car_area.global_transform.basis.z * speed_input)
	
	engine_pitch = abs((ball.linear_velocity.length()/10)/2.4)
	

	
	
		
	

	
	
func _process(delta):
	
	camera.look_at(car_area.transform.origin, Vector3(0,1,0))
	
	if not ground_ray.is_colliding():
		return
		
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)
	
	if rotate_input != 0 and speed_input != 0:
		smoke_particles_back.emitting = true
		smoke_particles_back.direction = Vector3(-rotate_input,0,0)
		
		smoke_particles_front.emitting = true
		smoke_particles_front.direction = Vector3(-rotate_input,0,0)
	else:
		smoke_particles_back.emitting = false
		smoke_particles_front.emitting = false

	
	front_right_wheel.rotation.z = rotate_input
	front_left_wheel.rotation.z = rotate_input
	
	if speed_input != 0:
		front_left_wheel.rotation.x += speed_input * wheel_spin
		front_right_wheel.rotation.x += speed_input * wheel_spin
		rear_left_wheel.rotation.x += speed_input * wheel_spin
		rear_right_wheel.rotation.x += speed_input * wheel_spin
		
	if engine_pitch == 0:
		engine_audio_player.pitch_scale = min_engine_pitch
	elif engine_pitch >= 3:
		engine_audio_player.pitch_scale = max_engine_pitch
	elif engine_pitch < 0:
		engine_audio_player.pitch_scale = min_engine_pitch
	else:
		engine_audio_player.pitch_scale = engine_pitch
	
	
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_area.global_transform.basis.rotated(car_area.global_transform.basis.y,rotate_input)
		car_area.global_transform.basis = car_area.global_transform.basis.slerp(new_basis,turn_speed * delta)
		car_area.global_transform = car_area.global_transform.orthonormalized()
		
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		car_area.rotation.z = lerp(car_area.rotation.z, t, 10 * delta)
		
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_area.global_transform, n.normalized())
	car_area.global_transform = car_area.global_transform.interpolate_with(xform, 10*delta)
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
func _on_car_becomes_unstable():
	if !engine_smoke_particles.emitting:
		engine_smoke_particles.emitting = true
	
func _on_car_blow_up():
	acceleration = 0
	car_explosion_player.play()
	car_explosion_particles.emitting = true
	ball.apply_central_impulse(Vector3(0,25,0))
	car_mesh.material_override = blown_car
	front_left_wheel.visible = false
	front_right_wheel.visible = false
	rear_left_wheel.visible = false
	rear_right_wheel.visible = false
	
func _on_car_repaired():
	engine_smoke_particles.emitting = false
	engine_smoke_particles.visible = false
	print("rep")


