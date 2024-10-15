extends Node2D

@export var spawn_rate: float = 3.0
@export var slime_total : int = 6 

@onready var timer = $SpawnTimer
@onready var initialSlime = $Slime
var slime_scene = preload("res://Scenes/Enemy/Slime.tscn") 
var slime_count : int = 0
var slime_total_count : int = 0


var is_spawning : bool = true
var id : int = 1


signal enemy_instance_died

func _ready():
	initialSlime.queue_free()
	timer.start(spawn_rate) 


func spawn_enemy():
	var spawn_area_width = 300
	var spawn_area_height = 300
	
	var random_x = randf_range(-spawn_area_width / 2, spawn_area_width / 2)
	var random_y = randf_range(-spawn_area_height / 2, spawn_area_height / 2)
	var random_position = Vector2(random_x, random_y)
	var new_slime = slime_scene.instantiate() 
	new_slime.id = id
	id = id + 1
	new_slime.add_to_group("Enemy")
	new_slime.position = self.position + random_position
	slime_total_count = slime_total_count + 1


	new_slime.connect("SlimeDied", self._on_slime_died)
	

	add_child(new_slime)  
	slime_count += 1 

func _on_spawn_timer_timeout():
	if slime_total_count >= slime_total:
		is_spawning = false
	elif slime_total_count < slime_total and slime_count < 3:
		spawn_enemy()
		print("Spawned a slime!")
	else:
		print("Too many slimes")


func _on_slime_died(loot):

	print("Slime died - SlimeSpawner")
	enemy_instance_died.emit(loot)
	slime_count -= 1




func get_is_spawning():
	return is_spawning
