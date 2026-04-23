extends Area2D
@export var explosion_scene: PackedScene
@onready var muzzle: Marker2D = $HeadMuzzle
@export var speed: float = 600.0
var additional_velocity: Vector2 = Vector2.ZERO
@onready var sprite = $Soda
var rotation_speed = 5
var source_node = null

func _ready():
	sprite.frame = randi_range(0, 2)
	rotation_speed = randi_range(3, 7) * (randi_range(0,1)-2)

func _process(delta: float) -> void:
	sprite.rotation += rotation_speed * delta

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
	if body == source_node:
		return # Ignore the creator
	
	body.take_damage(Vector2.from_angle(self.rotation) * 4)
	spawn_explosion()
	queue_free() # Destroy bullet on impact



func spawn_explosion():
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		# Add to the main scene (get_parent) so it stays put while bullet dies
		get_parent().add_child(explosion)
		explosion.global_position = muzzle.global_position
		
