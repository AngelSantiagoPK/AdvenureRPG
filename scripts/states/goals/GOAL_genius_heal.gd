extends State

class_name GoalGeniusHeal

@export var object: CharacterBody2D
@export var heal: int = 10

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	await get_tree().create_timer(300.0).timeout
	object.health_system.apply_heal(heal)
	object.health_bar.heal_and_update(object.health_system.current_health)
	success.emit()

func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	pass
