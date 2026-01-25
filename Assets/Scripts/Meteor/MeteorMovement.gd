extends RigidBody2D

@export var speed: float = 3
var PlayerDirection: Vector2

func rePath() -> void:
	if !GameController.player:
		GameController.findPlayer()
	PlayerDirection = (GameController.player.global_position - self.global_position).normalized()
	
func _ready() -> void:
	rePath()

func _process(delta: float) -> void:
	var prevPosition:Vector2 = global_position
	global_position.x = wrapf(global_position.x,0,get_viewport().size.x)
	global_position.y = wrapf(global_position.y,0,get_viewport().size.y)
	if prevPosition.distance_to(global_position) > 1:
		rePath()

func _physics_process(delta: float) -> void:
	if PlayerDirection == Vector2.ZERO:
		PlayerDirection = Vector2(randf()+1,randf()+1).normalized()
	var collide:KinematicCollision2D = move_and_collide(PlayerDirection * speed * delta)
	if collide:
		$Meteor_Audio.play()
		var collider:Object = collide.get_collider()
		if (collider.name.contains("Player")):
			GameController.player.find_child("Player_Health").takeDamage(1)
		queue_free()
