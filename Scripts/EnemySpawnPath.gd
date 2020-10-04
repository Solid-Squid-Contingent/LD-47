extends Path2D

onready var timer = $EnemySpawnTimer
var enemyScenes = [
	load("res://Scenes/Enemy.tscn"),
	load("res://Scenes/Cyborg.tscn"),
	load("res://Scenes/Knight.tscn")
]
export var minimumSpawnDistance = 500

var numberOfEnemies = 0

signal enemySpawned(enemy)

func _ready():
	randomize()
	spawnEnemy()

func getNewSpawnPosition():
	return curve.interpolate_baked(randf() * curve.get_baked_length(), false)

func spawnEnemy():
	var enemy = enemyScenes[randi() % enemyScenes.size()].instance()
	
	var attemptedSpawnPosition = getNewSpawnPosition()
	var player = get_node("../Player")
	
	while (player.position - attemptedSpawnPosition).length() < minimumSpawnDistance:
		attemptedSpawnPosition = getNewSpawnPosition()
	
	enemy.position = attemptedSpawnPosition
	
	get_parent().call_deferred("add_child", enemy)
	enemy.connect("enemyDied", $"../WowPlayer", "playSfx")
	enemy.connect("enemyKilledByPlayer", $"../KillSlowdownTimer", "slowDown")
	enemy.connect("enemyKilledByPlayer", $"../Player", "enemyDied")
	enemy.connect("enemyDied", self, "enemyDied")
	enemy.connect("enemyNotKilledByPlayer", $"../BooPlayer", "playSfx")
	emit_signal("enemySpawned", enemy)
	numberOfEnemies += 1
	
	timer.start(3 + pow(numberOfEnemies - 1, 2))

func enemyDied():
	numberOfEnemies -= 1
	if numberOfEnemies <= 0:
		spawnEnemy()

func _on_EnemySpawnTimer_timeout():
	spawnEnemy()

func _on_Player_playerDied():
	timer.stop()
