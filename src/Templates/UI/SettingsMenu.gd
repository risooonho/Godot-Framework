extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
func _on_CheckBox_toggled(button_pressed) -> void:
	OS.set_window_fullscreen(button_pressed)

func _on_Quit_pressed() -> void:
	set_visible(false)
#	global.set_can_talk(false)
	get_node("../../../../../Transition").fade_in(1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://src/Scenes/Title.tscn")

func _on_Close_pressed():
	set_visible(false)
