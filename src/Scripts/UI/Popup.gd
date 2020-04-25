extends Control

export (int) var set_gaps := 50

func _ready() -> void:
	if is_visible():
		set_visible(false)
	set_node_gaps("Panel")
	
	$Panel/VBoxContainer/HBoxContainerButtons/Close.connect("pressed", self, "_on_Close_pressed")
	$Panel/VBoxContainer/HBoxContainerButtons/Settings.connect("pressed", self, "_on_Settings_pressed")

func set_node_gaps(node: String, gap_size := set_gaps) -> void:
	get_node(node).margin_bottom -= set_gaps
	get_node(node).margin_top += set_gaps
	get_node(node).margin_left += set_gaps
	get_node(node).margin_right -= set_gaps

# Popup handlers
func popup() -> void:
	set_visible(true)

func popup_item_description(description: String) -> void:
	print("Popup item description")
	print(description)
	$ItemDescription.popup()
	$ItemDescription/VBoxContainer/Label.text = description

func hide() -> void:
	set_visible(false)

func _on_Settings_pressed() -> void:
	if not get_parent().get_parent().get_node("Settings/Popup").is_visible():
		get_parent().get_parent().hide_element("Appendix")
		get_parent().get_parent().popup_element("Settings")
	else:
		get_parent().get_parent().hide_element("Settings")

func _on_Close_pressed() -> void:
	if not global.get_can_talk():
		global.set_can_talk(true, false)
		get_parent().get_parent().hide_element("Appendix")
		get_parent().get_parent().hide_element("Settings")

func _on_CloseDescription_pressed() -> void:
	$ItemDescription.hide()
	$ItemDescription/VBoxContainer/Label.text = ""
