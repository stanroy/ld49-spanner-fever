extends Node

signal car_becomes_unstable
signal car_blow_up
signal car_repaired

onready var spanner_tracker = $Control/SpannerTracker
onready var win_timer = $WinTimer
onready var control_win = $ControlWin
onready var control_lose = $ControlLose
onready var button_next = $ControlWin/ButtonNext
onready var color_rect = $ControlWin/ColorRect
onready var global_timer = $GlobalTimer
onready var time_left = $Control/TimeLeft
onready var hint_timer = $HintTimer
onready var hint = $Control/Hint
onready var car_mesh = get_node("../Car")

var spanners_left_text = "Spanners Left: "

var level_1_spanners = 5
var level_2_spanners = 10
var level_3_spanners = 12
var level_4_spanners = 12

var level_1_timer = 21
var level_2_timer = 21
var level_3_timer = 31
var level_4_timer = 36

export var current_level = 0
export var current_spanners = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	hint_timer.start()
	
	connect("car_becomes_unstable",car_mesh,"_on_car_becomes_unstable")
	connect("car_blow_up",car_mesh,"_on_car_blow_up")
	connect("car_repaired",car_mesh,"_on_car_repaired")
	
	if current_level == 1:
		current_spanners = level_1_spanners
		global_timer.wait_time = level_1_timer
	if current_level == 2:
		current_spanners = level_2_spanners
		global_timer.wait_time = level_2_timer
	if current_level == 3:
		current_spanners = level_3_spanners
		global_timer.wait_time = level_3_timer
	if current_level == 4:
		current_spanners = level_4_spanners
		global_timer.wait_time = level_4_timer
		button_next.text = "THE END"
		
	time_left.text = "Time Left: " + str(global_timer.wait_time)
	
	global_timer.start()
	
	spanner_tracker.text = spanners_left_text + str(current_spanners)
		
	
	
func _process(delta):
#	
	time_left.text = "Time Left: " + str(int(global_timer.time_left))
	if int(global_timer.time_left) <= 2:
		emit_signal("car_becomes_unstable")
	

func _on_spanner_collected():
	current_spanners -= 1
	spanner_tracker.text = spanners_left_text + str(current_spanners)
	print("Left: " + str(current_spanners))
	
	if current_spanners == 0:
		win_timer.start()



func _on_WinTimer_timeout():
	emit_signal("car_repaired")
	spanner_tracker.visible = false
	time_left.visible = false
	global_timer.stop()
	control_win.visible = true


func _on_ButtonNext_pressed():
	if current_level == 1:
		get_tree().change_scene("res://Scenes/Level2.tscn")
	if current_level == 2:
		get_tree().change_scene("res://Scenes/Level3.tscn")
	if current_level == 3:
		get_tree().change_scene("res://Scenes/Level4.tscn")
	if current_level == 4:
		get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_GlobalTimer_timeout():
	spanner_tracker.visible = false
	time_left.visible = false
	current_spanners = -100
	control_lose.visible = true
	emit_signal("car_blow_up")


func _on_ButtonRetry_pressed():
	if current_level == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	if current_level == 2:
		get_tree().change_scene("res://Scenes/Level2.tscn")
	if current_level == 3:
		get_tree().change_scene("res://Scenes/Level3.tscn")
	if current_level == 4:
		get_tree().change_scene("res://Scenes/Level4.tscn")


func _on_HintTimer_timeout():
	hint.visible = false
