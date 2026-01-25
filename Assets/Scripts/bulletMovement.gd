extends RigidBody2D

@export var decay: float = 6
@export var penetration: bool = false
var speed: float
var direction: Vector2

func _ready() -> void:
	var deathTimer: Timer = Timer.new()
	add_child(deathTimer)
	deathTimer.wait_time = decay
	deathTimer.one_shot = true
	deathTimer.timeout.connect(func():
		queue_free())
	deathTimer.start()
	

func _physics_process(delta: float) -> void:
	var collide:KinematicCollision2D =  move_and_collide(direction.normalized() * speed)
	if collide:
		var collider: Node = collide.get_collider()
		if collider.name.contains("Meteor"):
			collider.queue_free() # Delete Meteor object
		if not penetration:
			queue_free() # delete Bullet on collision
