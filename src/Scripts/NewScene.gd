extends Node2D

export (String, FILE) var music_to_play

onready var player := get_node("Characters/Seeker")
onready var UI := player.get_node("Camera2D/UI")

# Set up the scene
func _ready() -> void:
	
	# Set global reference variables
	global.set_current_scene(name)
	
	# Disable the tint momentarily
	#$BG/Map/CanvasModulate/AnimationPlayer.play_backwards("set_tint")
	
	# Fade in the scene
	$Transition.visible = true
	$Transition.fade_out()
	
	# Start emitting particles
	if $Effects.has_node("Particles"): 
		$Effects/Particles.emit_all()
	
	# Play the level's theme
	if music_to_play:
		GlobalMusicPlayer.set_music(music_to_play)
	
	# SAVE DATA HANDLING HERE
	# Usually will set up story stuff based on the save data
	var save_data = global.get_save_data()
	if save_data.has(self.filename):
		print("Loading from save")
		
		if save_data[self.filename].has("dialogue_finished"):
			if save_data[self.filename]["dialogue_finished"]:
				global.set_can_talk(true)
		else:
			global.set_can_talk(true)
	
		# Set the position of the player according to the last time 
		# the player was in this scene
		if save_data[self.filename].has("exit_point"):
			# Set x and y separately because Vector2 is a Godot thing, not a JSON thing
			player.global_position.x = save_data[self.filename]["exit_point"]["position_x"]
			player.global_position.y = save_data[self.filename]["exit_point"]["position_y"]
			# Disable the exit node the player used previously
			get_node(save_data[self.filename]["exit_point"]["exit_node"]).monitoring = false
			yield(get_tree().create_timer(2.5), "timeout")
			get_node(save_data[self.filename]["exit_point"]["exit_node"]).monitoring = true
	else: 
		print("Creating new save entry for this level")
		
		# Update save data and autosave
#		UI.popup_element("SaveIndicator", 3)

		# Create the save entry for the level
		global.set_save_data(self.filename, {})
		
		global.set_save_data("global", self.filename, "current_scene")
		
#		global.set_save_data("global", {
#			"current_scene": self.filename
#		})

# Method for other nodes to use
# Fade to black and freeze player input and movement
func change_scene(scene: String, time:=1.0, delay_between_scenes:=0.0) -> void:
	$Transition.fade_in(time)
	yield(get_tree().create_timer(time+delay_between_scenes), "timeout")
	get_tree().change_scene(scene)
