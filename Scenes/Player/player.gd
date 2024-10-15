extends CharacterBody2D

var direction : Vector2
var is_attacking : bool = false
var can_grab_reward: bool = false

var currency = 0
@onready var animation_player = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var healthComponent = $HealthComponent
@onready var attackDelay = $AttackDelay
@export var speed = 400

var shield_texture = preload("res://Player Assets/Player_Shield_Done.png")

@onready var HurtboxUp = $HurtBox_up
@onready var HurtboxDown = $HurtBox_down
@onready var HurtboxLeft = $HurtBox_left
@onready var HurtboxRight = $HurtBox_right

@onready var HurtboxUpShape = $HurtBox_up/CollisionShape2D
@onready var HurtboxDownShape = $HurtBox_down/CollisionShape2D
@onready var HurtboxLeftShape = $HurtBox_left/CollisionShape2D
@onready var HurtboxRightShape = $HurtBox_right/CollisionShape2D
@onready var equippedItem = null


@onready var BlockboxUp = $BlockBox_up
@onready var BlockboxDown = $BlockBox_down
@onready var BlockboxLeft = $BlockBox_left
@onready var BlockboxRight = $BlockBox_right
@onready var BlockDurationTimer = $BlockBox_Duration
@onready var is_blocking : bool = false


@onready var default_sprite = preload("res://Resources/Weapons/Sword.tres")
var cache : Area2D
@onready var sword = preload("res://Resources/Weapons/Sword.tres")


func _ready():
	preload_resources()
	get_all_nodes()
	connect_all_signals()
	equip_item(sword)
	set_default_sprite()

func _physics_process(delta):
	get_input()
	move_and_slide()  
	var current_anim = $AnimationPlayer.current_animation


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("attack"):
		var attack_direction = get_local_mouse_position()
		attack(attack_direction)
		return
	if Input.is_action_just_pressed("Store") and can_grab_reward:
		equip_item(cache.get_reward())
		print("Equipped: ",cache.get_reward())
	if Input.is_action_pressed("Block"):
		var block_direction = get_local_mouse_position()
		block(block_direction)
		return
	elif Input.is_action_just_released("Block"):
		stop_blocking()
		
	input_direction = input_direction.normalized()
	velocity = input_direction * speed  
	animate(velocity)  

func animate(velocity: Vector2):
	if is_attacking or is_blocking:
		return
	set_default_sprite()
	if velocity == Vector2.ZERO:
		# Player is idle
		if direction.x < 0:
			sprite.flip_h = true
			animation_player.play("idle_side")
		elif direction.x > 0:
			sprite.flip_h = false
			animation_player.play("idle_side")
		elif direction.y < 0:
			animation_player.play("idle_up")
		elif direction.y > 0:
			animation_player.play("idle_down")
	else:
		# Player is moving
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0
			animation_player.play("walk_side")
		elif velocity.y < 0:
			animation_player.play("walk_up")
		elif velocity.y > 0:
			animation_player.play("walk_down")

		# Update direction for idle animations when player stops
		direction = velocity.normalized()

func attack(attack_direction):
	if is_attacking or is_blocking:
		return
	set_hurtbox_damage()
	is_attacking = true
	if self.equippedItem is Weapon and equippedItem.can_attack:
		sprite.hframes = equippedItem.hframes
		sprite.vframes = equippedItem.vframes
		sprite.texture = equippedItem.texture
		if equippedItem.item_name == "Spear":
			if abs(attack_direction.x) > abs(attack_direction.y):
				if attack_direction.x < 0:
					sprite.flip_h = true
					animation_player.play("spear_side")
					attackDelay.start()
					await attackDelay.timeout
					HurtboxLeft._set_active(true)
				elif attack_direction.x > 0:
					sprite.flip_h = false
					animation_player.play("spear_side")
					HurtboxRight._set_active(true)
			else:
				if attack_direction.y < 0:
					animation_player.play("spear_up")
					HurtboxUp._set_active(true)
				if attack_direction.y > 0:
					animation_player.play("spear_down")
					HurtboxDown._set_active(true)
		elif equippedItem.item_name == "Sword":
			if abs(attack_direction.x) > abs(attack_direction.y):
				if attack_direction.x < 0:
					sprite.flip_h = true
					animation_player.play("attack_side")
					HurtboxLeft._set_active(true)
				elif attack_direction.x > 0:
					sprite.flip_h = false
					animation_player.play("attack_side")
					HurtboxRight._set_active(true)
			else:
				if attack_direction.y < 0:
					animation_player.play("attack_up")
					HurtboxUp._set_active(true)
				if attack_direction.y > 0:
					animation_player.play("attack_down")
					HurtboxDown._set_active(true)

func block(block_direction):
	if is_blocking or is_attacking:
		return
	velocity = Vector2(0,0)
	is_blocking = true
	sprite.texture = shield_texture
	if abs(block_direction.x) > abs(block_direction.y):
		if block_direction.x < 0:
			sprite.flip_h = true
			BlockboxLeft._set_active(true)
			animation_player.play("shield_side")
		elif block_direction.x > 0:
			sprite.flip_h = false
			BlockboxRight._set_active(true)
			animation_player.play("shield_side")
	else:
		if block_direction.y < 0:
			animation_player.play("shield_up")
			BlockboxUp._set_active(true)
		elif block_direction.y > 0:
			BlockboxDown._set_active(true)
			animation_player.play("shield_down")

	




func stop_blocking():
	is_blocking = false
	disable_all_blockboxes()  
	animation_player.stop()  
	set_default_sprite()  
	
func _on_animation_finished(anim_name):
	if anim_name.begins_with("attack") or anim_name.begins_with("spear"):
		is_attacking = false
		disable_all_hurtboxes()
		set_default_sprite()




func disable_all_hurtboxes():
	HurtboxUp._set_active(false)
	HurtboxLeft._set_active(false)
	HurtboxRight._set_active(false)
	HurtboxDown._set_active(false)

func _on_hitbox_component_area_entered(area):
	if area.is_in_group("Enemy_Hurtbox"):
		print("Player taking damage")
		if area.has_method("get_damage"):
			var damage = area.get_damage()
			print("Damage: ", damage)
			take_damage(damage)

func take_damage(damage):
	healthComponent.damage(damage)

func set_default_sprite():
	sprite.hframes = 6
	sprite.vframes = 10
	sprite.texture = sword.texture
	
func set_hurtbox_damage():
	HurtboxDown.set_damage(equippedItem.damage)
	HurtboxUp.set_damage(equippedItem.damage)
	HurtboxLeft.set_damage(equippedItem.damage)
	HurtboxRight.set_damage(equippedItem.damage)

func grab_reward():
	can_grab_reward = true

func equip_item(item):
	equippedItem = item
	apply_weapon_hitboxes()
	
func preload_resources():
	pass
	#default_sprite = preload("res://Player Assets/Player.png")
	#spear_sprites = preload("res://Player Assets/spear_sprite_646.png")
	#sword = preload("res://Resources/Weapons/Sword.tres")

func get_all_nodes():
	get_node("HitboxComponent").connect("area_entered", Callable(self, "_on_hitbox_component_area_entered"))
	cache = get_parent().get_node("Cache")

func connect_all_signals():
	cache.connect("pickup_reward", Callable(self, "grab_reward"))
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	print("signals connected")
	
func apply_weapon_hitboxes():
	if(equippedItem != null):
		var shape = RectangleShape2D.new()
		shape.size = Vector2(equippedItem.hitbox_up_size.x, equippedItem.hitbox_up_size.y)
		HurtboxUpShape.set_shape(shape)
		HurtboxUpShape.position = Vector2(equippedItem.hitbox_up_offset.x, equippedItem.hitbox_up_offset.y)
		
		shape = RectangleShape2D.new()
		shape.size = Vector2(equippedItem.hitbox_down_size.x, equippedItem.hitbox_down_size.y)
		HurtboxDownShape.set_shape(shape)
		HurtboxDownShape.position = Vector2(equippedItem.hitbox_down_offset.x, equippedItem.hitbox_down_offset.y)
		
		shape = RectangleShape2D.new()
		shape.size = Vector2(equippedItem.hitbox_left_size.x, equippedItem.hitbox_left_size.y)
		HurtboxLeftShape.set_shape(shape)
		HurtboxLeftShape.position = Vector2(equippedItem.hitbox_left_offset.x, equippedItem.hitbox_left_offset.y)
		
		shape = RectangleShape2D.new()
		shape.size = Vector2(equippedItem.hitbox_right_size.x, equippedItem.hitbox_right_size.y)
		HurtboxRightShape.set_shape(shape)
		HurtboxRightShape.position = Vector2(equippedItem.hitbox_right_offset.x, equippedItem.hitbox_right_offset.y)
	

func _on_attack_delay_timeout():
	print("Attack delay")




func disable_all_blockboxes():
	BlockboxDown._set_active(false)
	BlockboxUp._set_active(false)
	BlockboxLeft._set_active(false)
	BlockboxRight._set_active(false)

func enable_all_blockboxes():
	BlockboxDown._set_active(true)
	BlockboxUp._set_active(true)
	BlockboxLeft._set_active(true)
	BlockboxRight._set_active(true)




func _on_block_box_duration_ready():
	print("Block finished")
