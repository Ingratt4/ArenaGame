extends Area2D

signal hurtbox_triggered(damaged_entity)
@export var damage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	_set_active(false)


func _set_active(active: bool):
	for shape in get_children():
		if shape is CollisionShape2D:
			shape.disabled = not active



func _on_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Player"):
		emit_signal("hurtbox_triggered", area)
		print("Hurtbox detection!")

func set_damage(new_damage : int):
	damage = new_damage
