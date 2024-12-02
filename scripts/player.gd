# AUTHOR: ANGEL SANTIAGO - DEC 1, 2024
extends CharacterBody2D

class_name Player

# GLOBAL VARIABLES
@onready var animated_sprite_2D: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $InventoryToggler
@onready var health_system: HealthSystem = $HealthSystem
@onready var on_screen_ui: OnScreenUI = $OnScreenUi
@onready var combat_system: CombatSystem = $CombatSystem
@onready var hit_stop_timer: Timer = $Timers/HitStopTimer

const SPEED = 5000.0

@export var health = 100

# FUNCTIONS
func _ready() -> void:
	health_system.init(health)
	health_system.died.connect(on_player_dead)
	health_system.damage_taken.connect(on_damage_taken)
	on_screen_ui.init_health_bar(health)
	combat_system.enemy_hit.connect(func (): await frame_freeze(0.5, 1.0))
	#end

func _physics_process(delta: float) -> void:
	
	if animated_sprite_2D.animation.contains("attack"):
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
		velocity.y = move_toward(velocity.y, 0, SPEED*delta)
	
	if velocity != Vector2.ZERO:
		animated_sprite_2D.play_movement_animation(velocity)
	else:
		animated_sprite_2D.play_idle_animation(velocity)
	
	move_and_slide()
	#end


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickupItem:
		inventory.add_item(area.inventory_item, area.stacks)
		area.queue_free()
	
	if area.get_parent() is Enemy:
		var damage_to_player = (area.get_parent() as Enemy).damage_to_player
		health_system.apply_damage(damage_to_player)
	#end


func on_damage_taken(damage: int):
	on_screen_ui.apply_damage_to_health(damage)
	#end


func on_player_dead():
	set_physics_process(false)
	combat_system.set_process_input(false)
	animated_sprite_2D.play('dead')
	#end


func frame_freeze(timeScale: float, duration: float):
	Engine.time_scale = timeScale
	hit_stop_timer.start()
	await hit_stop_timer.is_stopped()
	Engine.time_scale = 1.0


func setup_test_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://resources/weapons/sword/sword_inventory_item.tres")
	const GOLD_COIN = preload("res://resources/gold_coin/gold_coin.tres")
	
	inventory.add_item(SWORD_INVENTORY_ITEM, 1)
	inventory.add_item(GOLD_COIN, 100)
