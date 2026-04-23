extends CharacterBody2D
signal killed
signal hit(life)
signal update_sugar(sugar)
signal update_coins(coins)

@export var bullet_scene: PackedScene
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_sound_player: AudioStreamPlayer2D = $ShootSoundPlayer
@onready var no_coins_player: AudioStreamPlayer2D = $NoCoinsPlayer
@onready var collect_coin_player: AudioStreamPlayer2D = $CollectCoinPlayer

@onready var magnet_shape = $MagnetArea

@export var life = 5
@export var sugar = 0
@export var coins = 5
@export var speed = 300
@export var collect_range = 100
@export var bullet_spawn_distance: float = 80.0
##var velocity = Vector2.ZERO
var last_direction = "down"

@onready var sprite = $AnimatedSprite2D

func _process(delta):
	if Input.is_action_just_pressed("shoot") and coins > 0:
		if shoot_timer.is_stopped():
			coins -= 1
			update_coins.emit(coins)
			shoot()
			shoot_timer.start()
	
	if Input.is_action_just_pressed("shoot") and coins <= 0:
		no_coins_player.play()
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if(velocity.y < 0):
		$AnimatedSprite2D.animation = "walk_up"
		last_direction = "up"
	elif(velocity.y > 0):
		$AnimatedSprite2D.animation = "walk_down"
		last_direction = "down"
	elif(velocity.x < 0):
		$AnimatedSprite2D.animation = "walk_left"
		last_direction = "left"
	elif(velocity.x > 0):
		$AnimatedSprite2D.animation = "walk_right"
		last_direction = "right"
	

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "stand_" + last_direction
		
	move_and_slide()
		
func shoot():
	var b = bullet_scene.instantiate()
	b.additional_velocity = velocity
	get_tree().root.add_child(b)
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - muzzle.global_position).normalized()
	var spawn_pos = muzzle.global_position + (direction * bullet_spawn_distance)
	b.global_position = spawn_pos
	b.rotation = direction.angle()
	
	shoot_sound_player.play()
	
func take_damage(bullet_direction: Vector2):
	var material = sprite.material as ShaderMaterial
	material.set_shader_parameter("flash_modifier", 1.0)
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/flash_modifier", 0.0, 0.2)
	
	life -= 1
	hit.emit(life)
	if life <= 0:
		killed.emit()
	
func collect_coin():
	collect_coin_player.play()
	coins += 1
	update_coins.emit(coins)
	
	
func increase_magnet_range(amount: float):
	magnet_shape.shape.radius += amount


func _on_magnet_area_area_entered(area: Area2D) -> void:
	if area.has_method("start_magnetic_pull"):
		area.start_magnetic_pull(self)
