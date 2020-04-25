extends Node2D
func _ready():
	$transition_node.visible = true
	$transition_node.fade_out()

# Start button
func _on_Start_pressed():
	$transition_node.fade_in()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene("res://Scenes/day_1.tscn")
	pass # Replace with function body.

# Exit button
func _on_Exit_pressed():
	$transition_node.fade_in()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()
	pass # Replace with function body.
