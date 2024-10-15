extends Control

signal currency_changed
var player = null
var label = null
@onready var spear = preload("res://Resources/Weapons/Spear.tres")
func _on_player_entered_store(player_reference):
	if player_reference.is_in_group("Player"):
		player = player_reference
		connect("currency_changed", Callable(self, "update_currency_display"))
		label = player.get_node("Camera2D/Currency")
		print("Player entered the store with currency:", player.currency)
	else:
		print("non player in store")


func _on_upgrade_25_pressed():
	if(player.currency >= 25):
		player.currency -= 25
		label.text = "Currency: " + str(player.currency)
		currency_changed.emit()
	else:
		print("Not enough currency")
	
	

