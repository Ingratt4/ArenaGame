extends CharacterBody2D

@onready var healthComponent = $HealthComponent
@onready var hitboxComponent = $HitboxComponent
@onready var attack_timer = $AttackRange/AttackTimer
@onready var box_timer = $AttackRange/BoxTimer
@onready var pause_timer = $AttackRange/AttackPauseTimer
@onready var loot_component = $LootComponent
@onready var collision_box = $Collision
@export var speed = 300
@export var leap_speed = 200
@export var block_stun_timer = 1


var leap_timer = 0.0
var leap_duration =0.4


var player: Node2D = null
var player_pos = null


var is_in_attack_range : bool = false
var is_dead : bool = false  
var has_updated_player_pos : bool = false
var idle_cooldown : bool = false
var is_leaping : bool = false
var is_blocked : bool = false

var id : int 

signal SlimeDied

func _ready():
	var player_detection = $PlayerDetection
	player_detection.connect("player_detected", Callable(self, "_on_player_detected"))
	player_detection.connect("player_exited", Callable(self, "_on_player_exited"))
	
	# Connect the died signal to handle the death process
	healthComponent.connect("died", Callable(self, "_on_health_component_died"))
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))

func _on_player_detected(detected_player: Node):
	player = detected_player

func _on_player_exited(exited_player: Node):
	if player == exited_player:
		player = null

func _physics_process(delta: float):
	if is_dead or is_blocked or idle_cooldown:
		return 
		
	if player:

		var direction = (player.position - global_position).normalized()
		if is_leaping:
			leap_timer += delta
			
			velocity = direction * leap_speed
			if leap_timer >= leap_duration:
				is_leaping = false
				leap_timer = 0
				velocity = Vector2.ZERO
		elif player and !is_in_attack_range:
			$AnimationPlayer.play("move")
			velocity = direction * speed

		elif is_in_attack_range:
			if !has_updated_player_pos and player_pos == null:
				velocity = Vector2(0,0)
				player_pos = player.global_position
				has_updated_player_pos = true
				pause_timer.start()
				await pause_timer.timeout
				attack_timer.start()
				box_timer.start()
			
				#start leap
				is_leaping = true
				leap_timer = 0.0
	else:
		if !is_leaping:
			$AnimationPlayer.play("idle")
			velocity = Vector2.ZERO
		

	move_and_slide()

func _on_hitbox_component_area_entered(area):
	if area.is_in_group("Player_Hurtbox"):
		hitboxComponent.damage(area.damage)

func _on_health_component_died():
	print("Health component died called")
	print("Disabling collision box")
	disable_all_boxes()
	set_physics_process(false)  # Disables physics processing
	collision_layer = 0
	collision_mask = 0
	is_dead = true 
	print("Emitting SlimeDied")
	SlimeDied.emit(self.loot_component.coins)
	$AnimationPlayer.play("die")
	
	if not $AnimationPlayer.is_connected("animation_finished", Callable(self, "_on_animation_player_animation_finished")):
		$AnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()


func _on_attack_range_body_entered(body):
	if body.is_in_group("Player"):
		is_in_attack_range = true


func _on_attack_range_body_exited(body):
	if body.is_in_group("Player"):
		is_in_attack_range = false



func _on_attack_timer_timeout():
	print("Cooldown complete")
	has_updated_player_pos = false
	idle_cooldown = false
	player_pos = null
	print("Enabling attack area")
	$AttackRange/AttackArea.disabled = false
	


func _on_box_timer_timeout():
	print("Disabling attack area")
	$AttackRange/AttackArea.disabled = true

func _on_attack_pause_timer_timeout():
	print("Pause complete")

func blocked():
	self.velocity = Vector2(0,0)
	$AnimationPlayer.play("stunned")
	is_blocked = true
	$Block_Stun_Duration.start()
	await $Block_Stun_Duration.ready


func disable_all_boxes():
	$Collision.disabled = true
	$AttackRange/AttackArea.disabled = true
	$PlayerDetection/CollisionShape2D.disabled = true
	$HitboxComponent/CollisionShape2D.disabled = true
	$EnemyHurtbox/CollisionShape2D.disabled = true


func _on_block_stun_duration_timeout():
	is_blocked = false
	$AnimationPlayer.play("idle")
