extends Area2D

@export var reward = preload("res://Resources/Weapons/Spear.tres")
signal pickup_reward

func _ready():
	connect("pickup_item", Callable(self, "pickup_item"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var player = body
		pickup_reward.emit()
		print("pickup reward signal emitted")

		
		
func get_reward():
	return reward
	
		
	
		
		
