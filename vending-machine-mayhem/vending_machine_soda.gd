extends CharacterBody2D
signal killed
@export var soda_red_scene: PackedScene
@export var coin_scene: PackedScene

@export var life = 3
@export var speed = 100.0
@export var detection_range = 5000.0
@export var stop_range: float = 600.0
@export var shoot_range: float = 1000.0

@onready var sprite = $AnimatedSprite2D
var player = null

@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_sound_player: AudioStreamPlayer2D = $ShootSoundPlayer
@onready var hit_sound_player: AudioStreamPlayer2D = $HitSoundPlayer

@export var bullet_spawn_distance: float = 100.0

func _ready():
	# Find the player in the scene tree
	player = get_tree().get_first_node_in_group("player")
	shoot_timer.wait_time = randf_range(2, 3)
	shoot_timer.start()

func _physics_process(_delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if shoot_timer.is_stopped() and distance <= shoot_range:
			shoot()
			shoot_timer.start()
		else:
			if distance <= detection_range:
				var direction = (player.global_position - global_position).normalized()
				update_animation(direction)
				
				if distance > stop_range:
					velocity = direction * speed
				else:
					velocity = Vector2.ZERO
			else:
				velocity = Vector2.ZERO
		
		move_and_slide()

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		return

	# angle() returns radians from -PI to PI
	var angle = direction.angle() 
	
	# Convert angle to an index from 0 to 7
	# Adding PI shifts the range from (-PI, PI) to (0, 2*PI)
	var angle_deg = rad_to_deg(angle)
	
	if angle_deg > -22.5 and angle_deg <= 22.5:
		sprite.play("east")
	elif angle_deg > 22.5 and angle_deg <= 67.5:
		sprite.play("south-east")
	elif angle_deg > 67.5 and angle_deg <= 112.5:
		sprite.play("south")
	elif angle_deg > 112.5 and angle_deg <= 157.5:
		sprite.play("south-west")
	elif (angle_deg > 157.5) or (angle_deg <= -157.5):
		sprite.play("west")
	elif angle_deg > -157.5 and angle_deg <= -112.5:
		sprite.play("north-west")
	elif angle_deg > -112.5 and angle_deg <= -67.5:
		sprite.play("north")
	elif angle_deg > -67.5 and angle_deg <= -22.5:
		sprite.play("north-east")

func take_damage(bullet_direction: Vector2):
	hit_sound_player.play()
	var material = sprite.material as ShaderMaterial
	material.set_shader_parameter("flash_modifier", 1.0)
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/flash_modifier", 0.0, 0.2)
	
	var coins = randi_range(1, 2)
	
	for i in range(coins):
		var hit_direction: Vector2 = bullet_direction * randf_range(0.8, 1.2)
		var coin = coin_scene.instantiate()
		get_parent().add_child(coin)
		coin.global_position = global_position
		var random_dir = hit_direction.rotated(randf_range(-0.75, 0.75))
		coin.launch(random_dir)
	
	life -= 1
	
	if life <= 0:
		killed.emit()
		queue_free()
		
func shoot():
	var b = soda_red_scene.instantiate()
	b.source_node = self
	b.additional_velocity = velocity
	get_tree().root.add_child(b)
	var player_pos = player.global_position
	var direction = (player_pos - muzzle.global_position).normalized()
	var spawn_pos = muzzle.global_position + (direction * bullet_spawn_distance)
	b.global_position = spawn_pos
	b.rotation = direction.angle()
	
	shoot_sound_player.play()
