extends Control

signal cloak_timer_finished

onready var cloak_timer := $HSlider
onready var player := get_parent().get_parent().get_parent()

func _ready() -> void:
	set_visible(false)
	

func start_cloak_timer() -> void:
	player.is_cloaked = true
	player.collision_layer = 1
	set_visible(true)
	cloak_timer.value = 5
	$HSlider/Label.text = String(5)
	$HSlider/Timer.start()

func increment_cloak_timer() -> void:
	cloak_timer.value -= 1
	$HSlider/Label.text = String(cloak_timer.value)
	# Shrink the slider
	$HSlider.margin_left += 100.0
	$HSlider.margin_right -= 100.0
	# Reset
	if cloak_timer.value == 0:
		reset_cloak_timer()

func reset_cloak_timer() -> void:
	emit_signal("cloak_timer_finished")
	player.is_cloaked = false
	player.collision_layer = 5
	set_visible(false)
	# Reset the slider
	$HSlider.margin_left = -500
	$HSlider.margin_right = 500
	$HSlider/Timer.stop()
	cloak_timer.value = 5
	$HSlider/Label.text = String(5)

func _on_Timer_timeout() -> void:
	increment_cloak_timer()
