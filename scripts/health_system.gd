extends Node

class_name HealthSystem

signal died
signal update_health(current_health: int)
signal hit

@export var actor: Node2D
@onready var max_health: int = actor.max_health
var current_health: int


func init(health: int):
	max_health = health
	current_health = health


func apply_damage(damage: int):
	current_health = current_health - damage
	update_health.emit(current_health)
	hit.emit()

	if current_health <= 0:
		died.emit()
