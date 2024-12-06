extends Node

const PLAYER_SCENE = preload("res://resources/player/player.tscn")
@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint


func _ready() -> void:
	TransitionChangeManager.transition_done.connect(on_transition_done)
	var player = PLAYER_SCENE.instantiate()
	self.add_child(player)
	
	if TransitionChangeManager.is_transitioning:
		player.set_physics_process(false)
		player.set_process_input(false)
	player.position = player_spawn_point.position
	player.setup_test_inventory()
	#end


func on_transition_done():
	$Player.set_physics_process(true)
	$Player.set_process_input(true)
	#end


func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	TransitionChangeManager.player_spawn_position = Vector2.ZERO
	TransitionChangeManager.change_scene("res://scenes/main.tscn")
	#end
