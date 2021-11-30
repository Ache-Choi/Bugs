extends KinematicBody

export var speed : float = 30
export var acceleration : float = 10
export var air_acceleration : float = 5
export var gravity : float = 0.98
export var max_velocity : float = 54
#export var jump_power : float = 17

var velocity : Vector3
var y_velocity : float

onready var bodyCont = $playerCont
onready var body = $playerCont/playerMeshCont
onready var tween = $Tween
onready var animPlayer = $playerCont/playerMeshCont/AnimationPlayer

onready var currentDirNum = 0
onready var dirNumArray = [0, 1,  2,  3,   4,    5,    6,   7]
onready var rotDegArray = [0, 45, 90, 135, 180, -135, -90, -45]
onready var fromToArray = [0,0]
onready var xRotAmount = 25
onready var lastCollideHL = ''
var dbug


func _ready():
	dbug = GSignals.connect('playerShipShoot', self, 'player_ship_shoot')
	randomize()

func player_ship_shoot():
	animPlayer.play("shootBall")

func self_destroy(gemPos, discPos):
	dbug = [gemPos, discPos]
	GSignals.inst_sounds('lose')
#	GSignals.cam_shake()
	self.queue_free()

func _physics_process(delta):
	GVariables.playerPos = self.global_transform.origin

	if GVariables.gameOn:
		player_dir_move(delta)

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
	if direction != Vector3.ZERO:
		body.rotation_degrees.x = lerp(body.rotation_degrees.x, -30, .2)
	elif direction == Vector3.ZERO:
		body.rotation_degrees.x = lerp(body.rotation_degrees.x, 0, .2)

	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)


	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_velocity, max_velocity)
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)


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

func tween_rotation(from, to):
	tween.interpolate_property(bodyCont, 'rotation_degrees',from, to, 0.1,Tween.TRANS_LINEAR)
	tween.start()

func _on_Tween_tween_completed(object, key):
	bodyCont.rotation_degrees.y = rotDegArray[currentDirNum]
	dbug = [object, key]

func attack_rot_tween(from, to):
	$attackRotTween.interpolate_property(bodyCont, 'rotation_degrees',Vector3(bodyCont.rotation_degrees.x,from, bodyCont.rotation_degrees.z),
										 Vector3(bodyCont.rotation_degrees.x,to, bodyCont.rotation_degrees.z), 0.1,Tween.TRANS_LINEAR)
	$attackRotTween.start() 
