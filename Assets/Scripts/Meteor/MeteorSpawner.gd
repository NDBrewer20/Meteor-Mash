extends Node2D

@export var MeteorPrefab: PackedScene
@export var DifficultyCurve: Curve
@export var TimeToSpawn:Curve
var startTime:float
var MeteorSpawnTimer: Timer
var radius: int

func _ready() -> void:
	global_position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	startTime = Time.get_unix_time_from_system()
	radius = get_viewport().size.x if get_viewport().size.x > get_viewport().size.y else get_viewport().size.y 
	MeteorSpawnTimer = Timer.new()
	add_child(MeteorSpawnTimer)
	MeteorSpawnTimer.wait_time = TimeToSpawn.sample(0)
	MeteorSpawnTimer.one_shot = true
	MeteorSpawnTimer.timeout.connect(spawnMeteors)
	MeteorSpawnTimer.start()

func spawnMeteors() -> void:
	var currentTime:float = Time.get_unix_time_from_system()
	var elapsed:float = currentTime - startTime
	var numToSpawn:int = floor(DifficultyCurve.sample(elapsed))
	for i in numToSpawn:
		var instance:Node2D = MeteorPrefab.instantiate()
		add_child(instance,true)
		instance.global_rotation = randf_range(-180,180)
		instance.get_node("Meteor_Hitbox").scale *= randf_range(.7,1.2)
		instance.speed *= (randf_range(.7,1.2))
		var pos:Vector2 = generatePosition(global_position,radius)
		pos.x = clampf(pos.x,-10,get_viewport().size.x+10)
		pos.y = clampf(pos.y,-10,get_viewport().size.y+10)
		instance.global_position = pos
	MeteorSpawnTimer.wait_time = ceil(TimeToSpawn.sample(elapsed))
	MeteorSpawnTimer.start()

func generatePosition(center:Vector2, radi:float):
	var angle = randf_range(0,TAU)
	return Vector2(center.x + radi * cos(angle),center.y+radi*sin(angle))
