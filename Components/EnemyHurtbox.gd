extends Area2D

signal deal_damage(damage)
@export var damage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))



func _on_area_entered(area):
	if area.is_in_group("Player_Blockbox"):
		print("Blocked!")
	if area.is_in_group("Player_Hitbox"):
		print("Enemy Hurtbox detection!")
		deal_damage.emit(damage)
		
		
		

func get_damage():
	return damage
