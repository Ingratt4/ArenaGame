extends Node2D

@export var health_component : HealthComponent
# Called when the node enters the scene tree for the first time.

func damage(damage: int):
	if health_component:
		health_component.damage(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
