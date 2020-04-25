extends Area2D

export (String, FILE) var exit_scene

func _on_ExitPoint_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D and exit_scene:
		var current_root := body.get_parent().get_parent()
		# Track the exit points in the save file
		global.append_save_data(current_root.filename, "exit_point", {
			"position_x": body.position.x,
			"position_y": body.position.y,
			"exit_node": get_path()
		})
		current_root.change_scene(exit_scene)
