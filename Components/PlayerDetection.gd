extends Area2D

# Signal to emit when the player enters the detection area
signal player_detected(player)

# Signal to emit when the player exits the detection area
signal player_exited(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_entered and body_exited signals to handle player detection
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

# Function to handle when a body enters the detection area
func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		emit_signal("player_detected", body)

# Function to handle when a body exits the detection area
func _on_body_exited(body: Node):
	if body.is_in_group("Player"):
		emit_signal("player_exited", body)
