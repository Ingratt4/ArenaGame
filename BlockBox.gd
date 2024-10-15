extends Area2D

signal blockbox_triggered(damaged_entity)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	_set_active(false)


func _set_active(active: bool):
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.disabled = not active



func _on_area_entered(area):
	if area.is_in_group("Enemy_Hurtbox"):
		emit_signal("Blockbox_triggered", area)
		var target = area.get_parent()
		print("Blocked attack from:", target)
		target.blocked()
	
		
		print("Blockbox detection!")

