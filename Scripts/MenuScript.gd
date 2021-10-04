extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var button_hover_sound = $ButtonHoverSound
onready var menu_sound = $MenuSound

func _ready():
	menu_sound.play()


func _on_ButtonStart_pressed():
	menu_sound.stop()
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_ButtonExit_pressed():
	get_tree().quit()

func _on_ButtonStart_mouse_entered():
	button_hover_sound.play()
	button_hover_sound.stop()


func _on_ButtonExit_mouse_entered():
	button_hover_sound.play()
	button_hover_sound.stop()
