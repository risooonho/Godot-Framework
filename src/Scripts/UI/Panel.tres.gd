extends Panel

# Auto-hide
func _ready() -> void:
	if is_visible():
		set_visible(false)
	
	$NinePatchRect/VBoxContainer/Quit.connect("pressed", self, "_on_Quit_pressed")
	$NinePatchRect/VBoxContainer/Close.connect("pressed", self, "_on_Close_pressed")
	

# Popup handlers
func popup() -> void:
	set_visible(true)

func hide() -> void:
	set_visible(false)

# Hide the settings menu and unfreeze player movement
# Quit to Title
func _on_Quit_pressed() -> void:
	get_parent().get_parent().hide_element("Settings")
	get_parent().get_parent().hide_element("Appendix")
	global.set_can_talk(false)
	get_node("../../../../../../Transition").fade_in(1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://src/Scenes/Title.tscn")

func _on_Close_pressed() -> void:
	get_parent().get_parent().hide_element("Settings")
	get_parent().get_parent().popup_element("Appendix")
#	if not global.get_can_talk():
#		global.set_can_talk(true, false)
#		get_parent().get_parent().hide_element("Settings")
