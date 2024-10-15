extends Node

var round_in_progress : bool = true
var all_mobs_slain : bool = false
var levels = [1,2,3,4,5,6,7,8,9,10]
var next_round = null

func _ready():
	var RoundUI = preload("res://UI/RoundUI.tscn")
	next_round = RoundUI.instantiate()
	print("Global script ready")
	get_tree().root.add_child(next_round)

