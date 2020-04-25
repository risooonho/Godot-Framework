class_name AppendixItem extends TextureButton

onready var UI_root: VBoxContainer = get_parent().get_parent().get_parent().get_parent()
onready var item_description: String

func _on_AppendixItem_pressed() -> void:
	print("Open item description")
	print(item_description)
	UI_root.popup_item_description(item_description)
