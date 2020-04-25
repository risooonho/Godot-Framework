extends Node2D

export (float) var speed := 300.0

export (float) var JUMP_SPEED := 1500.0

export (float) var ALERT_ACCELERATION := 1.5

export (float) var reset_timer_wait_time := 1.0

onready var path: PoolVector2Array

onready var destination := $Position2D

# DONT TOUCH HERE I WORKED HARD FOR THIS TO WORK
func set_movement_path(start_position: Vector2, destination_position: Vector2) -> PoolVector2Array:
	path = $Navigation2D.get_simple_path(to_local(start_position), to_local(destination_position))
#	for point in len(path):
#		path[point] = to_local(path[point])
	$Line2D.points = path
	get_children()[len(get_children()) - 1].path = path
	return path

func create_movement_path(start_position: Vector2, destination_position: Vector2) -> PoolVector2Array:
	path = $Navigation2D.get_simple_path(to_local(start_position), to_local(destination_position))
#	for point in len(path):
#		path[point] = to_local(path[point])
	$Line2D2.points = path
	return path
