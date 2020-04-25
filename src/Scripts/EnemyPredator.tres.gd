extends "res://src/Scripts/NPC.gd"

signal movement_finished 

onready var speed: float = get_parent().speed
onready var reset_timer_wait_time: float = get_parent().reset_timer_wait_time
onready var JUMP_SPEED: float = get_parent().JUMP_SPEED
onready var ALERT_ACCELERATION: float = get_parent().ALERT_ACCELERATION

onready var starting_position := global_position
onready var destination_position:Vector2 = get_node("../Position2D").global_position

onready var player_detected := false
onready var is_idle := true
onready var path: PoolVector2Array
onready var movement_handler = get_parent()
onready var moving := false

# Setup
func _ready() -> void:
	rotate_body()
	$MovementResetTimer.wait_time = reset_timer_wait_time
	connect("movement_finished", self, "_on_movement_finished")

# Handles the enemy's various movements
func _physics_process(delta: float):
	# Chase the player
	if not moving:
		if player_detected:
			movement_handler.set_movement_path(global_position, global.get_player().global_position)
			rotate_body(global_position, global.get_player().global_position)
		elif is_idle:
			survey_movement(starting_position, destination_position)
		moving = true
	
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	# Move along the path until out of movement or the path ends.
	while distance_to_walk > 0.0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			# Main movement code here
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
			if not path.empty():
				rotate_body(position, path[0])
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

	if not path:
		print("Movement finished")
		emit_signal("movement_finished", global_position)

func _on_movement_finished(current_position: Vector2) -> void:
	$MovementResetTimer.start()
	set_physics_process(false)
	yield($MovementResetTimer, "timeout")
	set_physics_process(true)
#	if not global.get_player().is_cloaked:
	if player_detected:
		survey_movement(current_position, global.get_player().global_position)
	else:
		# Circling movement
		# Return
		if current_position != starting_position:
			survey_movement(current_position, starting_position)
			rotate_body(current_position, starting_position)
		# Away
		else:
			survey_movement()
			rotate_body(current_position, destination_position)

# Base enemy movement
func survey_movement(start := starting_position, destination := destination_position) -> void:
	movement_handler.set_movement_path(start, destination)

func stop_movement() -> void:
	path = PoolVector2Array([global_position])

func rotate_body(start := starting_position, destination := destination_position, flip := false) -> void:
	for node in get_node("Rotatable").get_children():
		node.rotation_degrees = -1 * rad2deg(start.direction_to(destination).angle_to(Vector2(0.0, 1.0)))
	$BodyShape.rotation_degrees = -1 * rad2deg(start.direction_to(destination).angle_to(Vector2(0.0, 1.0)))

# Detection mechanic
func _on_AttackArea_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			speed += JUMP_SPEED
			moving = false
#			if not $MovementResetTimer.is_stopped():
#				$MovementResetTimer.stop()
			print("Player detected")
			yield(get_tree(), "idle_frame")
			global.shake_camera(true, 0.4)
			frame_freeze()
			global.set_can_talk(false)
			speed = 0.0
			get_parent().get_parent().get_parent().get_node("Transition").brief_fade_in()
			global.get_player().get_node("SFX").play()

func _on_AttackArea_body_exited(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			player_detected = false
			$MovementResetTimer.start()
			yield($MovementResetTimer, "timeout")
			stop_movement()
			is_idle = true

# Effects
func frame_freeze(time := 0.5) -> void:
	get_tree().paused = true
	yield(get_tree().create_timer(time), "timeout")
	get_tree().paused = false

# Speed up when the player is in the vicinity
func _on_DetectionArea_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			if not $Alert.is_visible():
				player_detected = true
				moving = false
				speed *= ALERT_ACCELERATION
				$Alert.set_visible(true)
			else:
				if not $AlertResetTimer.is_stopped():
					$AlertResetTimer.stop()

func _on_DetectionArea_body_exited(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name and $Alert.is_visible():
			$AlertResetTimer.start()
			yield($AlertResetTimer, "timeout")
			player_detected = false
			speed = get_parent().speed
			$Alert.set_visible(false)
