extends Area2D
signal hit

@export var speed = 400

var last_direction = "down"

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
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
