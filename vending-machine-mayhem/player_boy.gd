extends CharacterBody2D
##signal hit

@export var bullet_scene: PackedScene
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_sound_player: AudioStreamPlayer2D = $ShootSoundPlayer

@export var speed = 300
@export var bullet_spawn_distance: float = 80.0
##var velocity = Vector2.ZERO
var last_direction = "down"

@onready var sprite = $AnimatedSprite2D

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		if shoot_timer.is_stopped():
			shoot()
			shoot_timer.start()
	
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
	
func take_damage():
	var material = sprite.material as ShaderMaterial
	material.set_shader_parameter("flash_modifier", 1.0)
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/flash_modifier", 0.0, 0.2)
	
