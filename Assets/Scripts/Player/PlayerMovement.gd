extends CharacterBody2D

@export var rotationSpeed: float = 5
@export var speed: float = 10
@export var friction: float = 5
@export var DashSpeed: float = 20
@export var maxDashCharges:int = 2
@export var DashRecharge:float = 5
@export var DashDelay:float = 0.25
@export var dashLookDir: bool = false
@export var DashChargesVFX:Array[Sprite2D]
var dashCharges:int
var dashVelocity: Vector2
var lastLookDir: Vector2
var dashRechargeTimer: Timer
var dashDelayTimer:Timer
var dashAllowed: bool = true
var player_health: Node

func _ready() -> void:
	dashCharges = maxDashCharges
	dashRechargeTimer = Timer.new()
	dashDelayTimer = Timer.new()
	add_child(dashRechargeTimer)
	add_child(dashDelayTimer)
	dashRechargeTimer.wait_time = DashRecharge
	dashDelayTimer.wait_time = DashDelay
	dashDelayTimer.one_shot = true
	dashRechargeTimer.timeout.connect(rechargeDash)
	dashDelayTimer.timeout.connect(func():
		dashAllowed = true)
	player_health = get_node("./Player_Health")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("Dash") and dashCharges > 0 && dashAllowed:
		Dash()

func Dash():
	if dashLookDir:
		velocity += Vector2(1,0).rotated(global_rotation) * DashSpeed
	else:
		var dirInput: Vector2 = Input.get_vector("Left","Right","Forward","Back").normalized()
		velocity += (dirInput.normalized() if dirInput != Vector2.ZERO else Vector2(1,0).rotated(global_rotation)) * DashSpeed
	consumeDashCharge()
	dashAllowed = false
	dashDelayTimer.start()
	player_health.allowDamage =false
	player_health.damageGraceTimer.start()
	$Player_Audio.play()

func consumeDashCharge():
	DashChargesVFX[dashCharges%2].hide()
	dashCharges-=1
	dashRechargeTimer.start()

func rechargeDash():
	if maxDashCharges > dashCharges:
		dashCharges+=1
		DashChargesVFX[dashCharges%2].show()

func _process(delta: float) -> void:
	global_position.x = wrapf(global_position.x,0,get_viewport().size.x)
	global_position.y = wrapf(global_position.y,0,get_viewport().size.y)

func _physics_process(delta: float) -> void:
	# move the player
	var dirInput: Vector2 = Input.get_vector("Left","Right","Forward","Back")
	if velocity.length() > 0:
		velocity = lerp(velocity,Vector2.ZERO,delta*friction)
	velocity += dirInput.normalized() * speed * delta
	move_and_collide(velocity)
	
	# Rotate the player
	var lookDirInput: Vector2 = Input.get_vector("LLeft","LRight","LForward","LBack")
	var mouseMoved: bool = Input.get_last_mouse_velocity().length() > 0
	var lookAtPoint: Vector2 = global_position + lastLookDir.normalized()
	if(lookDirInput.length() > 0 || mouseMoved):
		if(mouseMoved):
			lookDirInput = (get_global_mouse_position() - global_position)
			lookAtPoint = global_position + lookDirInput.normalized()
		else:
			lookAtPoint = global_position + lookDirInput.normalized()
		lastLookDir = lookDirInput
	rotation = lerp_angle(rotation, global_position.angle_to_point(lookAtPoint),delta*rotationSpeed)
