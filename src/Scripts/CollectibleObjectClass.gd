class_name CollectibleObject extends StaticBody2D

export (String, FILE) var interaction_script

export (Texture) var inventory_sprite

export (Texture) var inventory_sprite_hover

export (String) var item_description

onready var stats := {}
onready var appendix_system: VBoxContainer

func collect() -> void:
#	queue_free()
#	yield(get_tree().create_timer(1.0), "timeout")
	$SFX.play()
	queue_free()

# Update the appendix when collected
func update_appendix() -> void:
	appendix_system = global.get_player().appendix_system
	for node in appendix_system.get_node("Row%d" % global.current_appendix_index).get_children():
		print("Looping through the %d row" % global.current_appendix_index)
		# Find an empty spot in the list for the new item
		if not node.texture_normal:
			node.disabled = false
			node.texture_normal = inventory_sprite
			node.item_description = item_description
			if inventory_sprite_hover:
				node.texture_hover = inventory_sprite_hover
			return
	# Move to next row when the current row is filled
	global.current_appendix_index += 1
	for node in appendix_system.get_node("Row%d" % global.current_appendix_index).get_children():
		print("Looping through the %d row" % global.current_appendix_index)
		# Find an empty spot in the list for the new item
		if not node.texture_normal:
			node.disabled = false
			node.texture_normal = inventory_sprite
			node.item_description = item_description
			return

func add_item() -> void:
	for node in appendix_system.get_node("Row%d" % global.current_appendix_index).get_children():
		print("Looping through the %d row" % global.current_appendix_index)
		# Find an empty spot in the list for the new item
		if not node.texture_normal:
			node.disabled = false
			node.texture_normal = inventory_sprite
			node.item_description = item_description
			if inventory_sprite_hover:
				node.texture_hover = inventory_sprite_hover
			return
