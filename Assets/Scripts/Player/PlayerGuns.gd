extends Node2D

@export var bulletSpeed: float = 10
@export var attackDelay: float = .66
@export var bulletPrefab: PackedScene
var PlayerReference: Node2D
var attackTimer: Timer
var canAttack: bool = true

func _ready() -> void:
	PlayerReference = GameController.player
	attackTimer = Timer.new()
	add_child(attackTimer)
	attackTimer.one_shot = true
	attackTimer.wait_time = attackDelay
	attackTimer.timeout.connect(func():
		canAttack = true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Fire") && canAttack:
		var dir: Vector2 = Vector2(1,0).rotated(PlayerReference.global_rotation)
		var instance:Node2D = bulletPrefab.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.speed = bulletSpeed
		instance.direction = dir
		instance.global_rotation = dir.angle()
		instance.global_position = $Gun_Spawnpoint.global_position
		canAttack = false
		attackTimer.start()
		$Gun_Audio.play()
