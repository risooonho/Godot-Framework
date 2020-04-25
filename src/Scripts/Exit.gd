extends Area2D

# Connect signals 
func _ready():
	self.connect("body_entered", self, "exit")

# Exit function
func exit(body):
	print(body)
	if body.get_parent().name == "Player":
		print("change scene")
		get_node("../..").change_scene("res://Scenes/Prototype.tscn")