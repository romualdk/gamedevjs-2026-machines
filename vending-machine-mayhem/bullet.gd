extends Area2D

@export var speed: float = 600.0
var additional_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var bullet_velocity = transform.x * speed
	##position += (bullet_velocity + additional_velocity) * delta
	position += (bullet_velocity) * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(Vector2.from_angle(self.rotation) * 4)
	queue_free()
