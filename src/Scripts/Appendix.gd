extends Control

export (int) var set_gaps := 50

func _ready() -> void:
	set_node_gaps("Popup/Panel")
#	set_node_gaps($Panel/HBoxContainer)
	
func set_node_gaps(node: String, gap_size := set_gaps) -> void:
	get_node(node).margin_bottom -= set_gaps
	get_node(node).margin_top += set_gaps
	get_node(node).margin_left += set_gaps
	get_node(node).margin_right -= set_gaps
