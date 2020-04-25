extends CanvasLayer

func popup_element(menu: String, time_until_hidden:= 0) -> void:
	get_node(menu).set_visible(true)
	if time_until_hidden != 0:
		yield(get_tree().create_timer(time_until_hidden), "timeout")
		get_node(menu).set_visible(false)

func hide_element(menu: String) -> void:
	get_node(menu).set_visible(false)
