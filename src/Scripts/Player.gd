extends KinematicBody2D

# Default scale = 50
export (int) var SPEED_SCALE := 25

export (bool) var auto_set_camera_limit := true

export (float) var camera_shake_amount_x := 3.0
export (float) var camera_shake_amount_y := 3.0

export (float) var camera_pan_amount := 1.0

# Initialize variables
onready var ACCELERATION := 200 * SPEED_SCALE
onready var MAX_SPEED := 500 * SPEED_SCALE

onready var motion := Vector2(0, 0)
onready var player_animation := $Sprite
# Store the direction the player's hearding towards to set the animation correctly
onready var current_direction := 0
onready var area := $InteractableArea
onready var UI := $Camera2D/UI

# Initializeer
# Connect the interactable area's signals to interaction handlers
func _ready() -> void:
	# Set camera limit according to level's size
	if auto_set_camera_limit:
		print("Auto-set camera limits might cause a crash. Disable 'Auto Set Camera Limit' if it happens.")
		$Camera2D.limit_right = get_node("../../BG/Map").get_texture().get_size().x * get_node("../../BG/Map").scale.x
		$Camera2D.limit_bottom = get_node("../../BG/Map").get_texture().get_size().y * get_node("../../BG/Map").scale.y
	area.connect("area_entered", self, "_on_InteractableArea_entered")
	area.connect("area_exited", self, "_on_InteractableArea_exited")

# Input handler
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("open_settings"):
		if not UI.get_node("Settings").visible:
			# Freeze player movement
			if global.get_can_talk():
				global.set_can_talk(false)
				UI.popup_element("Settings")
		else:
			if not global.get_can_talk():
				global.set_can_talk(true, false)
				UI.hide_element("Settings")
	
	if Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)
		player_animation.play("walking")
		current_direction = -1
		$Camera2D.set_v_offset(-camera_pan_amount)
		
	elif Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
		player_animation.play("walking")
		current_direction = 1
		$Camera2D.set_v_offset(camera_pan_amount)
	else:
		$Camera2D.set_v_offset(0.0)
		motion.y = 0

	# Sideway motion
	if Input.is_action_pressed("ui_right"):
		motion.x = min(pow(motion.x, 2.0) + ACCELERATION, MAX_SPEED)
		player_animation.play("walking")
#			player_animation.flip_h = true
		current_direction = 2
		$Camera2D.set_h_offset(camera_pan_amount/3)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(-pow(motion.x, 2.0) - ACCELERATION, -MAX_SPEED)
		player_animation.play("walking")
#			player_animation.flip_h = false
		current_direction = 2
		$Camera2D.set_h_offset(-camera_pan_amount/3)
	else:
		$Camera2D.set_h_offset(0.0)
		motion.x = lerp(motion.x, 0.0, 1.0)

	# Play idle animation based on current direction if standing still
	# 0 is idle
	# 1 is forward
	# -1 is backward
	# 2 is sideways
	if motion == Vector2(0, 0):
		match(current_direction):
			-1:
				player_animation.play("idle_front")
			0:
				player_animation.play("idle_front")
			1:
				player_animation.play("idle_front")
			2:
				player_animation.play("idle_front")
	
	move_and_slide(motion * delta)
