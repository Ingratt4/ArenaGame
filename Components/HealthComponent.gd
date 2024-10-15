extends Node2D
class_name HealthComponent

@export var max_health : int
@onready var healthBar = $HealthBar
var current_health : int

signal health_changed(new_health: int)
signal died
signal death_completed

func _ready():
	current_health = max_health
	healthBar.value = max_health
	


func damage(damageValue: int):
	current_health -= damageValue
	current_health = clamp(current_health, 0, max_health)
	healthBar.value = current_health
	health_changed.emit()
	
	if(current_health == 0):
		die()
		#get_parent().queue_free()

func heal(healValue: int):
	current_health += healValue

func die():
	died.emit()
	

