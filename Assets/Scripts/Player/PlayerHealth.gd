extends Node2D

@export var healthMax:int = 7
@export var damageGrace:float = 1.5
@export var healthReference: Array[Sprite2D]
var health:int
var damageGraceTimer: Timer
var allowDamage: bool = true

func _ready() -> void:
	health = healthMax
	damageGraceTimer = Timer.new()
	add_child(damageGraceTimer)
	damageGraceTimer.wait_time = damageGrace
	damageGraceTimer.one_shot = true
	damageGraceTimer.timeout.connect(func():
		allowDamage = true)

func takeDamage(damage:int) -> void:
	if !allowDamage:
		return
	if GameController.player.dashCharges <= 0:
		health-=damage
		if healthReference[health]:
			healthReference[health].hide()
	else:
		GameController.player.consumeDashCharge()
	allowDamage = false
	damageGraceTimer.start()
	$Health_Audio.play()
	if health <= 0:
		get_tree().change_scene_to_file("res://Assets/Scenes/Game_Over.tscn")
