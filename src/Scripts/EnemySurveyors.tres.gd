extends "res://src/Scripts/NPC.gd"

signal movement_finished 

# References
onready var speed: float = get_parent().speed
onready var reset_timer_wait_time: float = get_parent().reset_timer_wait_time
onready var starting_position := global_position
onready var destination_position: Vector2 = get_node("../Position2D").global_position
onready var raycast: RayCast2D = get_node("RayCast2D")
onready var movement_handler: Node2D = get_parent()
onready var path: PoolVector2Array
onready var root: Node2D = get_parent().get_parent().get_parent()

# Flags
onready var player_in_sight := false
onready var player_detected := false
onready var is_idle := true
onready var on_alert := false
onready var is_moving := false

func _ready() -> void:
	rotate_body()
	raycast.add_exception(get_node("../../../BG/Map/Bounds"))
	$ResetTimer.wait_time = reset_timer_wait_time
	connect("movement_finished", self, "_on_movement_finished")

# Handles the enemy's various movements
func _physics_process(delta) -> void:
	if not is_moving:
		if player_detected:
			if not player_is_hidden():
				rotate_body(global_position, global.get_player().global_position)
				# Make the enemy go over the player's past position a bit
#				var new_path = movement_handler.create_movement_path(global_position, global.get_player().global_position)
#				print(new_path.length)
#				new_path.length *= 1.2
#				path = new_path
				movement_handler.set_movement_path(global_position, global.get_player().global_position)
		# Default movement for enemy
		elif is_idle:
			survey_movement(starting_position, destination_position)
		is_moving = true

	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move along the path until out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
			if not path.empty():
				rotate_body(position, path[0])
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

	# Called at the end of a movement
	if not path:
		print("Movement finished")
		emit_signal("movement_finished", global_position)

# Loops the enemy default movement
func _on_movement_finished(current_position: Vector2) -> void:
	freeze()
	
	# Return
#	if current_position != starting_position:
#		survey_movement(current_position, starting_position)
#		rotate_body(current_position, starting_position)
#	# Away
#	else:
#		survey_movement()
#		rotate_body(current_position, destination_position)
	yield($ResetTimer, "timeout")
	if current_position.distance_to(starting_position) > current_position.distance_to(destination_position):
		survey_movement(current_position, starting_position)
		rotate_body(current_position, starting_position)
	else:
		survey_movement(current_position, destination_position)
		rotate_body(current_position, destination_position)

# Various movements for the enemy
func survey_movement(start := starting_position, destination := destination_position) -> void:
	movement_handler.set_movement_path(start, destination)

func stop_movement() -> void:
	path = PoolVector2Array([global_position])

func rotate_body(start := starting_position, destination := destination_position) -> void:
	for node in get_node("Rotatable").get_children():
		node.rotation_degrees = -1 * rad2deg(start.direction_to(destination).angle_to(Vector2(0.0, 1.0)))
	$BodyShape.rotation_degrees = -1 * rad2deg(start.direction_to(destination).angle_to(Vector2(0.0, 1.0)))

# Detection mechanic
func _on_DetectionArea_body_entered(body) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			if not player_is_hidden():
				if not global.get_player().is_cloaked:
					player_in_sight = true
					if not on_alert:
						# The enemy stops for a second then runs a check to see if the player
						# is still in sight
						on_alert = true
						$BarkAlert.set_visible(true)
						bark()
						freeze()
#						stop_movement()
						yield($ResetTimer, "timeout")
						if player_in_sight:
							player_detected = true
							is_moving = false
							if not $ResetTimer.is_stopped():
								$ResetTimer.stop()
							print("Player detected")
					else:
						player_detected = true
						is_moving = false
						print("Player detected")
	return

func _on_DetectionArea_body_exited(body) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			if not global.get_player().is_cloaked:
				if player_in_sight:
					player_in_sight = false
					bark(false)
#					if not $ResetTimer.is_stopped():
#						$ResetTimer.stop()
#						set_physics_process(true)
					print("Player out of view")

# Kill the player
func _on_DamageArea_body_entered(body) -> void:
	if body as KinematicBody2D:
			if body.name == global.current_player_name:
				if not player_is_hidden():
					if not global.get_player().is_cloaked:
						if on_alert:
							print("DAMAGE")
							global.shake_camera(true, 0.3)
							frame_freeze()
							global.get_player().get_node("SFX").play()
							root.change_scene("res://src/Scenes/Title.tscn", 1.0, 2.0)

# Cast ray to the player to determine if they are hidden
func player_is_hidden() -> bool:
	# The ray intersects another object, we can deduce that the player is hidden behind something
	# So the enemy will ignore the player
	raycast.set_cast_to(to_local(global.get_player().global_position) * 3.0)
	raycast.force_raycast_update()
#	if raycast.get_collider() as StaticBody2D:
#		pass
#	elif raycast.get_collider() as KinematicBody2D:
#		if raycast.get_collider().name == global.current_player_name:
#			print("PLAYER FOUND.")
#			#rotate_body(global_position, global.get_player().global_position)
#			#movement_handler.set_movement_path(global_position, global.get_player().global_position)
#			return false
	if raycast.get_collider().get_parent().name == global.current_player_name:
		print("Player found")
		return false
	print("Player hidden")
	return true

# Woof
func bark(val := true) -> void:
	print("Feedback for player")
	$Bark.set_visible(val)

# Artificial delay
func freeze() -> void:
	$ResetTimer.start()
	set_physics_process(false)
	yield($ResetTimer, "timeout")
	set_physics_process(true)

# Effects
func frame_freeze(time := 0.4) -> void:
	get_tree().paused = true
	yield(get_tree().create_timer(time), "timeout")
	get_tree().paused = false
