extends Item
class_name Weapon

@export var texture: Texture2D = preload("res://Player Assets/spear_sprite_646.png")
@export var hitbox_up_size: Vector2
@export var hitbox_down_size: Vector2
@export var hitbox_left_size: Vector2
@export var hitbox_right_size: Vector2

@export var hitbox_up_offset: Vector2
@export var hitbox_down_offset: Vector2
@export var hitbox_left_offset: Vector2
@export var hitbox_right_offset: Vector2

@export var damage : float = 0

@export var hitbox_delay: float = 0

@export var hframes : int = 0
@export var vframes : int = 0



var can_attack : bool = true

func start_attack_delay(timer: Timer):
	if not can_attack:
		return
	
	can_attack = false
	timer.wait_time = hitbox_delay
	timer.start()

func reset_attack():
	can_attack = true
