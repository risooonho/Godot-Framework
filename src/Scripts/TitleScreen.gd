extends Node2D

export (String, FILE) var intro_scene

export (String, FILE) var music_to_play

func _ready() -> void:
	$Transition.visible = true
	$Transition.fade_out()
	# Start music
	if music_to_play:
		GlobalMusicPlayer.set_music(music_to_play)
		GlobalMusicPlayer.set_volume(GlobalMusicPlayer.get_volume())
	# Autofocus
	#$Control/Start.grab_focus()

# Start button
func _on_Start_pressed() -> void:
	$Transition.fade_in()
	# Reset global variables
	var save_file := File.new()
	save_file.open(global._save_name, File.WRITE)
	save_file.store_line(to_json({
	"global": {
		"current_scene": null
	}}))
	save_file.close()
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene(intro_scene)

# Exit button
func _on_Exit_pressed() -> void:
	$Transition.fade_in()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()

# Load the save file
func _on_Load_pressed() -> void:
	var save_data: Dictionary = global.get_save_data()
	print(save_data)
	# Load the last scene the player was in
	if save_data["global"]["current_scene"]:
		$AudioStreamPlayer.play()
		# Disable all buttons
		_on_any_Button_pressed()
		# Change to the loaded scene
		$Transition.fade_in()
		yield(get_tree().create_timer(2.0), "timeout")
		GlobalMusicPlayer.stop_music()
		get_tree().change_scene(save_data["global"]["current_scene"])
		return
	# No save
	$Control/NoSave.popup()
	yield(get_tree().create_timer(2.0), "timeout")
	$Control/NoSave.hide()

# Disable other buttons once a button is pressed
func _on_any_Button_pressed() -> void:
	for node in $Control.get_children():
		if node as TextureButton:
			node.disabled = true

func _on_MenuButton_pressed():
	$Control/Settings.set_visible(!$Control/Settings.is_visible())
