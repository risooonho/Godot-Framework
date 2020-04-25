extends HSlider

func _on_VolumeSlider_value_changed(value: float) -> void:
	GlobalMusicPlayer.set_volume(value)
	if value == -20:
		GlobalMusicPlayer.set_volume(-10000.0)

# Automatically set the volume on entering the scene
func _ready() -> void:
	GlobalMusicPlayer.set_volume(GlobalMusicPlayer.get_volume())
	if not GlobalMusicPlayer.get_volume() == -10000.0:
		value = GlobalMusicPlayer.get_volume()
	else:
		value = -20
