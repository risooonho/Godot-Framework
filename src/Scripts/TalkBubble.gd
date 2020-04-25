extends Node2D

# Auto-hide the bubble
func _ready() -> void:
	self.modulate.a = 0
	global.connect("dialogue_finished", self, "_on_dialogue_finished")

func play_animation(anim := "default", play_sfx := true) -> void:
	get_node("AnimationPlayer").play("create_bubble")
	get_node("AnimatedSprite").play(anim)
	if play_sfx:
		get_node("AudioStreamPlayer2D").play()
	
func stop_animation() -> void:
	get_node("AnimationPlayer").play_backwards("create_bubble")
	get_node("AnimatedSprite").stop()

func _on_dialogue_finished() -> void:
	# Check if player is still in vicinity of an NPC with dialogue
	if global.get_current_body() as Area2D and global.get_current_body().get_parent().interaction_script as String:
		play_animation()
