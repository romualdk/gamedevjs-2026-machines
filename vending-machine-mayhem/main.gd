extends Node2D

@export var soda_machine_scene: PackedScene
@export var chips_machine_scene: PackedScene
@export var coin_scene: PackedScene

@export var min_spawn_distance: float = 1000.0
@export var max_spawn_distance: float = 1500.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawnTimer = $Game/SpawnTimer
@onready var infoLabel = $Game/Player/InfoLabel
@onready var coinsInfo = $HUD/HBoxContainer/CenterContainer/HBoxContainer/HBoxContainer/CoinsInfo
@onready var sugarInfo = $HUD/HBoxContainer/CenterContainer/HBoxContainer/HBoxContainer3/SugarInfo
@onready var playerInfo = $HUD/HBoxContainer/CenterContainer/HBoxContainer/HBoxContainer2/PlayerInfo
@onready var waveInfo = $HUD/HBoxContainer/Control/WaveInfo
@onready var enemyKilledPlayer = $Game/EnemyKilledPlayer
@onready var gameOverTimer = $Game/GameOverTimer
@onready var waveClearLabel = $WaveClearScreen/CenterContainer/VBoxContainer/WaveClearLabel
@onready var upgradeSpeed = $WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/UpgradeSpeed
@onready var upgradeVelocity = $WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/UpgradeVelocity
@onready var upgradeCooldown = $WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/UpgradeCooldown
@onready var upgradeMagnet = $WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/UpgradeMagnet
@onready var upgradeLife = $WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/UpgradeLife
@onready var upgradeLabel = $WaveClearScreen/CenterContainer/VBoxContainer/UpgradeLabel
@onready var newWaveTimer = $Game/NewWaveTimer

var wave = 1
var spawntime = 2
var enemiesSpawned = 1
var enemiesKilled = 0
var enemiesToSpawn = 2

var sugarForUpgrade = 10
var sugarForLife = 50

func _ready():
	randomize()
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
		upgrade()

func showAllUpgradeCards():
	upgradeSpeed.show()
	$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator1.show()
	upgradeVelocity.show()
	$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator2.show()
	upgradeCooldown.show()
	$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator3.show()
	upgradeMagnet.show()
	$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator4.show()
	upgradeLife.show()
	
func hideUpgradeCard(num):
	if num == 1:
		upgradeSpeed.hide()
	elif num == 2:
		$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator1.hide()
		upgradeVelocity.hide()
	elif num == 3:
		$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator2.hide()
		upgradeCooldown.hide()
	elif num == 4:
		$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator3.hide()
		upgradeMagnet.hide()
	elif num == 5:
		$WaveClearScreen/CenterContainer/VBoxContainer/HBoxContainer/VSeparator4.hide()
		upgradeLife.hide()

func upgrade():
	waveClearLabel.text = "WAVE " + str(wave) + " CLEAR"
	
	var numbers = [1, 2, 3, 4, 5]
	numbers.shuffle()
	
	showAllUpgradeCards()
	hideUpgradeCard(numbers[0])
	hideUpgradeCard(numbers[1])
	
	if player.sugar >= sugarForUpgrade:
		upgradeLabel.text = "CHOOSE YOUR UPGRADE"
		upgradeSpeed.disabled = false
		upgradeVelocity.disabled = false
		upgradeCooldown.disabled = false
		upgradeMagnet.disabled = false
		upgradeLife.disabled = false
	else:
		upgradeLabel.text = "NOT ENOUGH SUGAR"
		upgradeSpeed.disabled = true
		upgradeVelocity.disabled = true
		upgradeCooldown.disabled = true
		upgradeMagnet.disabled = true
		upgradeLife.disabled = true
		
		wave += 1
		newWaveTimer.start()
		
	get_tree().paused = true
	$WaveClearScreen.show()

func updateWaveInfo():
	waveInfo.text = "Wave " + str(wave) + "  (" + str(enemiesToSpawn - enemiesKilled) + ")"

func _on_vending_machine_soda_killed() -> void:
	machineKilled()
	

func init_wave(wave_number):
	get_tree().paused = false
	$WaveClearScreen.hide()
	
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
		
	var random_angle = randf_range(0, 2 * PI)
	var random_dist = randf_range(min_spawn_distance, max_spawn_distance)
	
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_dist
	
	enemy_instance.global_position = player.global_position + offset
	
	add_child(enemy_instance)
	enemy_instance.killed.connect(machineKilled)

func _on_coin_spawn_timer_timeout() -> void:
	spawn_coin_randomly()

func spawn_coin_randomly():
	var coin_instance
	coin_instance = coin_scene.instantiate()
		
	var random_angle = randf_range(0, 2 * PI)
	var random_dist = randf_range(300, 1000)
	
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_dist
	coin_instance.global_position = player.global_position + offset
	
	add_child(coin_instance)

func _on_player_update_coins(coins: Variant) -> void:
	coinsInfo.text = str(coins)

func _on_player_update_sugar(sugar: Variant) -> void:
	sugarInfo.text = str(sugar)
	if player.sugar >= sugarForLife:
		player.life += 1
		player.sugar -= sugarForUpgrade
		playerInfo.text = str(player.life)
		sugarInfo.text = str(player.sugar)

func _on_player_hit(life: Variant) -> void:
	playerInfo.text = str(life)
	if life == 0:
		gameOverTimer.start()


func _on_new_wave_timer_timeout() -> void:
	init_wave(wave)

func nextWave():
	wave += 1
	init_wave(wave)

func _on_upgrade_speed_pressed() -> void:
	player.speed *= 1.15
	player.sugar -= sugarForUpgrade
	sugarInfo.text = str(player.sugar)
	nextWave()

func _on_upgrade_velocity_pressed() -> void:
	player.bullet_speed *= 1.15
	player.sugar -= sugarForUpgrade
	sugarInfo.text = str(player.sugar)
	nextWave()

func _on_upgrade_cooldown_pressed() -> void:
	player.upgradeCooldown()
	player.sugar -= sugarForUpgrade
	sugarInfo.text = str(player.sugar)
	nextWave()

func _on_upgrade_magnet_pressed() -> void:
	player.upgradeMagnet()
	player.sugar -= sugarForUpgrade
	sugarInfo.text = str(player.sugar)
	nextWave()

func _on_upgrade_life_pressed() -> void:
	player.life += 1
	player.sugar -= sugarForUpgrade
	playerInfo.text = str(player.life)
	sugarInfo.text = str(player.sugar)
	nextWave()
