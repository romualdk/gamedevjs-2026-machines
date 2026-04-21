extends CharacterBody2D
@export var soda_red_scene: PackedScene

@export var speed = 100.0
@export var detection_range = 5000.0
@export var stop_range: float = 600.0
@export var shoot_range: float = 1000.0

@onready var sprite = $AnimatedSprite2D
var player = null

@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_sound_player: AudioStreamPlayer2D = $ShootSoundPlayer

@export var bullet_spawn_distance: float = 100.0

func _ready():
	# Find the player in the scene tree
	player = get_tree().get_first_node_in_group("player")
	print(player)

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
		
func shoot():
	var b = soda_red_scene.instantiate()
	b.additional_velocity = velocity
	get_tree().root.add_child(b)
	var player_pos = player.global_position
	var direction = (player_pos - muzzle.global_position).normalized()
	var spawn_pos = muzzle.global_position + (direction * bullet_spawn_distance)
	b.global_position = spawn_pos
	b.rotation = direction.angle()
	
	shoot_sound_player.play()
