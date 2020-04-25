extends Node

# signal to handle dialogue events
# just like the old SMRT times
signal dialogue_finished 

# global variables
# now with static typing
onready var _can_talk := true setget set_can_talk, get_can_talk
onready var _current_scene: String setget set_current_scene, get_current_scene
onready var _current_body: Area2D setget set_current_body, get_current_body
onready var _top_down := true setget set_top_down, get_top_down
onready var start_camera_shake := false
onready var current_player_name := "Evan"
#onready var current_player_name := "Helen"

# Save file name/location
onready var _save_name := "user://AWoO.save"
# Dev environment
onready var env := "dev"

# Temporary container for global variables
onready var temp_variables := {}

# Top-down movement check getters and setters
func set_top_down(value: bool) -> void:
	_top_down = value
func get_top_down() -> bool:
	return _top_down

# Shake the camera
func shake_camera(val: bool, end_time := 2.0) -> void:
	if val:
		start_camera_shake = val
		if end_time != 0.0:
			yield(get_tree().create_timer(end_time), "timeout")
			start_camera_shake = false
	else:
		start_camera_shake = val

# Dialogue check getters and setters
func set_can_talk(value: bool, emit_signal := true) -> void:
	_can_talk = value
	if value and emit_signal:
		# Signal emits whenever a dialogue is finished
		# Used for creating events involving dialogues
		emit_signal("dialogue_finished")
	elif value == false:
		# false means starting a dialogue
		# hide the talk bubble
		get_player().get_node("TalkBubble").modulate.a = 0
func get_can_talk() -> bool:
	return _can_talk

# Current scene check getters and setters 
func set_current_scene(value: String) -> void:
	_current_scene = value
func get_current_scene() -> String:
	return _current_scene

# Current body the player is interacting with check getters and setters 
func set_current_body(value: Area2D) -> void:
	_current_body = value
func get_current_body() -> Area2D:
	return _current_body

# Get the player from anywhere in the codebase
func get_player():
	if _current_scene:
		if get_tree().get_root().has_node("%s/Characters/" % _current_scene+ "%s" % current_player_name):
			return get_tree().get_root().get_node("%s/Characters/"  % _current_scene + "%s" % current_player_name) as Node
	return null

# SAVE SYSTEM

# Create a save file if one doesn't exist
func _ready() -> void:
	if get_save_data() and env != "dev":
		return
	var save_file := File.new()
	save_file.open(_save_name, File.WRITE)
	save_file.store_line(to_json({
	"global": {
		"current_scene": null
	}}))
	save_file.close()

# Set a key in the save file
func set_save_data(key: String, val, _subkey := "") -> void:
	var save_file: File = File.new()
	# Stop if the save file doesn't exist
	if not save_file.file_exists(_save_name):
		return
	save_file.open(_save_name, File.READ_WRITE)
	var data: Dictionary = parse_json(save_file.get_as_text())
	if _subkey != "":
		data[key][_subkey] = val
	else:
		data[key] = val
	save_file.store_line(to_json(data))
	save_file.close()

# Append a subkey to an already existing key
func append_save_data(key: String, subkey_name: String, subkey_val) -> void:
	var current_save_data = get_save_data()
	if current_save_data.has(key):
		#print("Add a new subkey to %s" % key)
		current_save_data[key][subkey_name] = subkey_val
		# Set the save file to the new save with the subkey added
		set_save_data(key, current_save_data[key])

# Load the save file 
func get_save_data() -> Dictionary:
	var save_file: File = File.new()
	# Stop if the save file doesn't exist
	if not save_file.file_exists(_save_name):
		return {}
	save_file.open(_save_name, File.READ)
	var data: Dictionary = parse_json(save_file.get_as_text())
	save_file.close() 
	return data
