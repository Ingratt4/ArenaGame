extends Node2D

@onready var player = $Player  # Reference to the player
@onready var currency_label = $Player/Camera2D/Currency
@onready var slime_spawner = $SlimeSpawner
@onready var round_ui = $Player/Camera2D/NextRoundUI

@onready var roundbutton = round_ui.get_node("ColorRect/HBoxContainer/NextRound")

func _ready():

	roundbutton.connect("pressed", Callable(self, "on_round_button_pressed"))
	round_ui.PROCESS_MODE_WHEN_PAUSED
	find_enemy()

func update_currency_display():
	currency_label.text = "Currency: " + str(player.currency)

func pickup_item():
	print("Signal pickup item")


func check_round():
	pass
func on_round_button_pressed():
	print("round button pressed")
func show_round_ui():

	round_ui.show()
	
func check_all_enemies_dead():
	pass

func find_enemy():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var health_component = enemy.get_node("HealthComponent")
	


func _on_spawner_location_spawner_enemy_died(loot):
	player.currency += loot
	update_currency_display()
