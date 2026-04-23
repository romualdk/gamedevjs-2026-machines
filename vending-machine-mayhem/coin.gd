extends Area2D

@onready var sprite = $AnimatedSprite2D

var target_player: Node2D = null
var is_magnetized: bool = false
var pull_speed: float = 50.0 
var acceleration: float = 1000.0

func _process(delta: float) -> void:
	if is_magnetized and target_player:
		pull_speed += acceleration * delta
		var direction = global_position.direction_to(target_player.global_position)
		global_position += direction * pull_speed * delta

func start_magnetic_pull(player_node: Node2D):
	target_player = player_node
	is_magnetized = true

func launch(direction: Vector2):
	var travel_distance = randf_range(40, 80)
	var target_pos = global_position + (direction * travel_distance)
	var duration = 0.6
	
	var tween = create_tween().set_parallel(true)
	
	# 1. Move the whole Area2D to the landing spot
	tween.tween_property(self, "global_position", target_pos, duration)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	# 2. Animate the SPRITE specifically to fake a jump arc
	var jump_tween = create_tween()
	# Up
	jump_tween.tween_property(sprite, "position:y", -30, duration / 2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Down (The "Land")
	jump_tween.tween_property(sprite, "position:y", 0, duration / 2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		
	# Optional: Add a small second bounce
	jump_tween.tween_property(sprite, "position:y", -10, 0.2)
	jump_tween.tween_property(sprite, "position:y", 0, 0.2)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.collect_coin()
		queue_free()
