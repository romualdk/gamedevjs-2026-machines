extends Area2D

@export var speed: float = 600.0
var additional_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Move the bullet forward based on its rotation
	# Vector2.RIGHT * speed moves it on its local X-axis
	var bullet_velocity = transform.x * speed
	position += (bullet_velocity + additional_velocity) * delta
	## position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Delete the bullet when it leaves the screen to prevent lag
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	queue_free()
