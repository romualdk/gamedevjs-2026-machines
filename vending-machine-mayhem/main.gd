extends Node2D

@export var enemy_scene: PackedScene 

@export var min_spawn_distance: float = 1000.0
@export var max_spawn_distance: float = 1500.0

@onready var player = get_tree().get_first_node_in_group("player")

func _on_spawn_timer_timeout() -> void:
	if player:
		spawn_enemy_randomly()
		
		
func spawn_enemy_randomly():
	# Create an instance of the enemy
	var enemy_instance = enemy_scene.instantiate()
	
	# 2. Calculate a random point in a circle
	var random_angle = randf_range(0, 2 * PI)
	var random_dist = randf_range(min_spawn_distance, max_spawn_distance)
	
	# Convert Polar coordinates (angle/dist) to Cartesian (x/y)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_dist
	
	# Set position relative to the player
	enemy_instance.global_position = player.global_position + offset
	
	# 3. Add to the scene
	add_child(enemy_instance)
