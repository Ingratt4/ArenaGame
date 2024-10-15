extends Node2D

# Preload the SlimeSpawner scene
@export var slime_spawner_scene: PackedScene = preload("res://Scenes/Enemy/slime_spawner.tscn")
signal spawner_enemy_died
# Function to create a SlimeSpawner at this location
func spawn_slime_spawner():
	
	var spawner_instance = slime_spawner_scene.instantiate()
	spawner_instance.connect("enemy_instance_died", self._on_enemy_instance_died)
	add_child(spawner_instance)
	spawner_instance.position = Vector2.ZERO 
	
	#spawner_instance.enemy_instance_died.connect(self._on_enemy_instance_died())

func _ready():

	spawn_slime_spawner()


func _on_enemy_instance_died(loot):
	print("Enemy died from spawner_location")
	print("emitting spawner_enemy_died")
	spawner_enemy_died.emit(loot)




