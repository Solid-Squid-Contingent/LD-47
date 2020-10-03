extends "res://Scripts/IceScater.gd"

signal playerDied

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar
onready var sprite = $Sprite

func _ready():
	pass

func collideWithIceScater(collider):
	pass

func kill():
	$"../ArenaCamera".make_current()
	emit_signal("playerDied")
	queue_free()

func setSpriteRotation(rotation):
	sprite.rotate(rotation)

func getDirection():	
	var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	return Vector2(x,y)

func _process(delta):
	spinUp(delta)
	
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			boost()
