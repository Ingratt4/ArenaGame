extends Node2D

@onready var store = $ShopUI
@onready var upgrade = $ColorRect/VBoxContainer/Upgrade25
@onready var big_upgrade = $ColorRect/VBoxContainer/Upgrade50
signal in_store
var spear = "res://Resources/Weapons/Spear.tres"

var player = null
var is_in_store : bool = false


func _ready():
	connect("in_store", Callable(store, "_on_player_entered_store"))



func _process(delta):
	if is_in_store:
		store.show()
	else:
		store.hide()


func _on_shop_area_body_entered(body):
	if body.is_class("StaticBody2D"):
		return
	print("Player in shop area - from store node")
	print(body)
	player = body
	is_in_store = true
	in_store.emit(player)

	

func _on_shop_area_body_exited(body):
	is_in_store = false
	player = null
	store.hide()
