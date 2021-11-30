extends KinematicBody

export var speed : float = 35
export var acceleration : float = 15
export var air_acceleration : float = 5
export var gravity : float = 1.5
export var max_velocity : float = 54
export var jump_power : float = 70

var velocity : Vector3
var y_velocity : float
onready var bodyCont = $playerCont
onready var body = $playerCont/playerMeshCont
onready var tween = $Tween
onready var can_jump = true
onready var currentDirNum = 0
onready var dirNumArray = [0, 1,  2,  3,   4,    5,    6,   7]
onready var rotDegArray = [0, 45, 90, 135, 180, -135, -90, -45]
onready var fromToArray = [0,0]
#onready var xRotAmount = 25
onready var playerAnim = $playerCont/playerMeshCont/gorillaMesh/AnimationPlayer
onready var deadAnim = $playerCont/playerMeshCont/gorillaMesh/gorillaDeadAnim
onready var state = 'run'
onready var idleState = true
onready var canAttack = true
onready var attackTimer = $attackTimer
onready var airAttackPos = $playerCont/airAttackPos
onready var attackCount = 0
onready var attackRot = 0
onready var hpTexture = $playerCont/hpPanel/cont/Viewport/TextureProgress
onready var hpText = $playerCont/hpPanel/cont/Viewport/Label
onready var hpBar = $playerCont/hpPanel
onready var leftGlovesAttach = $playerCont/playerMeshCont/gorillaMesh/ArmatureGorilla/Skeleton/rightGloves
onready var rightGlovesAttach= $playerCont/playerMeshCont/gorillaMesh/ArmatureGorilla/Skeleton/leftGloves

var dBug

func _ready():
	playerAnim.play("idle")
	dBug = GSignals.connect('playerAttack', self, 'attack')
	hpTexture.value = GVariables.gorillaHP
	hpText.text = str(GVariables.gorillaHP)
	set_gloves()

func set_gloves():
	if GVariables.gorillaGlovesOn == true:
		leftGlovesAttach.show()
		rightGlovesAttach.show()
	else:
		leftGlovesAttach.hide()
		rightGlovesAttach.hide()
	
func update_hp_bar(damageAmount):
	hpBar.update_hp(damageAmount)

func _physics_process(delta):
	GVariables.playerPos = self.global_transform.origin
		
	if GVariables.gameOn:
		player_dir_move(delta)

func rotate_from_to():
	fromToArray[1] = currentDirNum
	if fromToArray[0] != currentDirNum:
		var rotNum = rotate_right_left(fromToArray[0], currentDirNum)
		for i in rotDegArray:
			if bodyCont.rotation_degrees.y > i and bodyCont.rotation_degrees.y < (i+45):
				bodyCont.rotation_degrees.y = i
		tween_rotation(Vector3(0,bodyCont.rotation_degrees.y,0), Vector3(0,bodyCont.rotation_degrees.y+rotNum,0))
		fromToArray[0] = currentDirNum

func rotate_right_left(from, to):
	# to right
	var tempFrom = from
	var toLeftDif = 0
	if from != to:
		while tempFrom != to:
			tempFrom += 1
			if tempFrom == 8:
				tempFrom = 0
			toLeftDif += 1

	if toLeftDif < 4:
		return (toLeftDif*45)
	elif toLeftDif > 4:
		var newRot = 8 - toLeftDif 
		return -(newRot*45)
	else:
		if body.rotation_degrees.y > 180:
			return -180 
		else:
			return 180

func player_dir_move(delta):
	var direction = Vector3()

	if Input.is_action_pressed("up"):
		if Input.is_action_pressed("right") and Input.is_action_pressed("up"):
			currentDirNum = 7
			direction += Vector3(1,0,-1)
			rotate_from_to()
		elif Input.is_action_pressed("left") and Input.is_action_pressed("up"):
			currentDirNum = 1
			direction += Vector3(-1,0,-1)
			rotate_from_to()
		elif Input.is_action_pressed("up"):
			currentDirNum = 0
			direction += Vector3(0,0,-1)
			rotate_from_to()

	elif Input.is_action_pressed("down"):
		if Input.is_action_pressed("right") and Input.is_action_pressed("down"):
			currentDirNum = 5
			direction += Vector3(1,0,1)
			rotate_from_to()
		elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
			currentDirNum = 3
			direction += Vector3(-1,0,1)
			rotate_from_to()
		elif Input.is_action_pressed("down"):
			currentDirNum = 4
			direction += Vector3(0,0,1)
			rotate_from_to()
	elif Input.is_action_pressed("left"):
		currentDirNum = 2
		direction += Vector3(-1,0,0)
		rotate_from_to()
	elif Input.is_action_pressed("right"):
		currentDirNum = 6
		direction += Vector3(1,0,0)
		rotate_from_to()

	direction = direction.normalized()

	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)

	if is_on_floor():
		can_jump = true
		y_velocity = -0.01
		if direction != Vector3.ZERO:
			if state == 'run':
				playerAnim.playback_speed = 1.8
				playerAnim.play("run")
			elif state == 'onFloor':
				speed = 20
				playerAnim.play("onFloor")
			elif state == 'attack':
				speed = 5
				playerAnim.playback_speed = 2
				playerAnim.play("groundAttack")
				if attackCount == 0:
					attackCount = 1
					GSignals.inst_gorilla_ground_fx('noGloves', bodyCont.global_transform.origin, attackRot)
					attack_rot_tween(bodyCont.rotation_degrees.y, attackRot)
		else:
			playerAnim.playback_speed = 1
			if state == 'onFloor':
				playerAnim.play("onFloor")
			elif state == 'attack':
				speed = 5
				playerAnim.playback_speed = 2
				playerAnim.play("groundAttack")
				if attackCount == 0:
					attackCount = 1
					GSignals.inst_gorilla_ground_fx('noGloves', bodyCont.global_transform.origin, attackRot)
					attack_rot_tween(bodyCont.rotation_degrees.y, attackRot)
			else:
				playerAnim.play("idle")
	else:
		y_velocity = clamp(y_velocity - gravity, -max_velocity, max_velocity)
		if state == 'attack':
			state = 'onFloor'
			playerAnim.playback_speed = 1.2
			playerAnim.play("jumpAttack")
		
	if Input.is_action_just_pressed("jump") and can_jump:
		playerAnim.stop()
		can_jump = false
		state = 'onFloor'
		playerAnim.playback_speed = 1
		playerAnim.play("jump")
		y_velocity = jump_power

	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

func attack(rotY):
	if canAttack:
		canAttack = false
		attackTimer.start()
		state = 'attack'
		attackRot = rotY

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'groundAttack':
		state = 'run'
		speed = 35
		playerAnim.play("idle")
		attack_rot_tween(bodyCont.rotation_degrees.y,rotDegArray[currentDirNum])

	if anim_name == 'onFloor':
		speed = 35
		state = 'run'
		playerAnim.stop()
	if anim_name == 'jump':
		speed = 35

func tween_rotation(from, to):
	tween.interpolate_property(bodyCont, 'rotation_degrees',from, to, 0.1,Tween.TRANS_LINEAR)
	tween.start()

func _on_Tween_tween_completed(object, key):
	bodyCont.rotation_degrees.y = rotDegArray[currentDirNum]
	dBug = [object, key]

func _on_attackTimer_timeout():
	canAttack = true
	attackCount = 0

func attack_rot_tween(from, to):
	$attackRotTween.interpolate_property(bodyCont, 'rotation_degrees',Vector3(bodyCont.rotation_degrees.x,from, bodyCont.rotation_degrees.z),
										 Vector3(bodyCont.rotation_degrees.x,to, bodyCont.rotation_degrees.z), 0.1,Tween.TRANS_LINEAR)
	$attackRotTween.start() 



