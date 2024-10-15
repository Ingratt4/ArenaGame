extends Node

var inventory = {}

func add_item(item : Item):
	inventory[item.item_name] = item

func print_inventory():
	for item_name in inventory.keys():
		var item = inventory[item_name]
		print(item + ",")

func get_inventory():
	return inventory

func get_item_in_inventory(requested_item : String):
	for item_name in inventory.keys():
		var item = inventory[item_name]
		if(item.item_name == requested_item):
			return item
	print("Item not found")
	return null
	
