extends Node2D

@export var soda_machine_scene: PackedScene
@export var chips_machine_scene: PackedScene

@export var min_spawn_distance: float = 1000.0
@export var max_spawn_distance: float = 1500.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawnTimer = $Game/SpawnTimer
@onready var infoLabel = $Game/Player/InfoLabel
@onready var coinsInfo = $HUD/HBoxContainer/CenterContainer/HBoxContainer/HBoxContainer/CoinsInfo
@onready var playerInfo = $HUD/HBoxContainer/CenterContainer/HBoxContainer/HBoxContainer2/PlayerInfo
@onready var waveInfo = $HUD/HBoxContainer/Control/WaveInfo
@onready var enemyKilledPlayer = $Game/EnemyKilledPlayer
@onready var gameOverTimer = $Game/GameOverTimer

var wave = 1
var spawntime = 2
var enemiesSpawned = 1
var enemiesKilled = 0
var enemiesToSpawn = 2

func _ready():
	init_wave(1)

func _on_game_over_timer_timeout() -> void:
	trigger_game_over()

func trigger_game_over():
	player.hide()
	$GameOverScreen.show() 
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func machineKilled():
	enemiesKilled += 1
	enemyKilledPlayer.play()
	updateWaveInfo()
	
	if enemiesKilled == enemiesToSpawn:
		wave += 1
		init_wave(wave)

func updateWaveInfo():
	#waveInfo.text = "Wave " + str(wave) + " (" + str(enemiesKilled) + " / " + str(enemiesToSpawn) + ")"
	waveInfo.text = "Wave " + str(wave) + "  (" + str(enemiesToSpawn - enemiesKilled) + ")"

func _on_vending_machine_soda_killed() -> void:
	machineKilled()
	

func init_wave(wave_number):
	wave = wave_number
	spawntime = 2
	if wave_number == 1:
		enemiesSpawned = 1
		enemiesToSpawn = 2
	else:
		enemiesSpawned = 0
		enemiesToSpawn	= wave * 2
	enemiesKilled = 0
	spawnTimer.wait_time = spawntime
	spawnTimer.start()
	updateWaveInfo()

func _on_spawn_timer_timeout() -> void:
	if player and enemiesSpawned < enemiesToSpawn:
		enemiesSpawned += 1
		spawn_enemy_randomly()

func spawn_enemy_randomly():
	var n = randi_range(0, 1)
	var enemy_instance
	
	if n == 0:
		enemy_instance = soda_machine_scene.instantiate()
	else:
		enemy_instance = chips_machine_scene.instantiate()
	
	# 2. Calculate a random point in a circle
	var random_angle = randf_range(0, 2 * PI)
	var random_dist = randf_range(min_spawn_distance, max_spawn_distance)
	
	# Convert Polar coordinates (angle/dist) to Cartesian (x/y)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_dist
	
	# Set position relative to the player
	enemy_instance.global_position = player.global_position + offset
	
	
	# 3. Add to the scene
	add_child(enemy_instance)
	enemy_instance.killed.connect(machineKilled)

func _on_player_update_coins(coins: Variant) -> void:
	coinsInfo.text = str(coins)

func _on_player_hit(life: Variant) -> void:
	playerInfo.text = str(life)
	if life == 0:
		gameOverTimer.start()
