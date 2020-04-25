extends KinematicBody2D

# Base NPC script for the Character template to inherit from

export (Color) var color # COLOR OF THE TEXT

export (float, 0.0, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

export (bool) var self_destruct := false

onready var animation: Sprite

func _ready() -> void:
	if get_children().has("Sprite"):
		animation = $Sprite
	
	# Ensure object (im)permanance
	var save_data: Dictionary = global.get_save_data()
	if self_destruct and save_data.has(get_parent().get_parent().filename):
		if save_data[get_parent().get_parent().filename].has("picked_up_item"):
			queue_free()
# Dialogue handler 
func talk() -> void:
	# Talk if the character has dialogue
	if (interaction_script):
		global.set_can_talk(false)
		MSG.start_dialogue(interaction_script, self)
		# Some space to add dynamic events here
		yield(global, 'dialogue_finished')
		if self_destruct:
			set_visible(false)
			interaction_script = null
			$InteractableArea.monitorable = false
			global.append_save_data(get_parent().get_parent().filename, "picked_up_item", true)
	else: 
		print('No dialogue available for the character')
