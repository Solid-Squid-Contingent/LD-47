extends "res://Scripts/IceScater.gd"

var corpseScene = load("res://Scenes/Corpse.tscn")
onready var player = $"../Player"

func _ready():
	pass

func hitIceScater(collision):
	var damageToOther = damageDealt()
	if getHit(collision.collider, collision.collider.damageDealt()):
		damageToOther = 0
	collision.collider.getHit(self, damageToOther)

func kill():
	if !is_queued_for_deletion():
		var corpse = corpseScene.instance()
		corpse.position = position
		corpse.rotation = rotation
		corpse.velocity = velocity
		corpse.rotationSpeed = rotationSpeed
		get_parent().add_child(corpse)
		
		get_node("../HUD/ScoreLabel").increaseScore()
		queue_free()

func getDirection():
	if player:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)

func _process(delta):
	spinUp(delta)
