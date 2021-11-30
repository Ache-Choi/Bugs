extends KinematicBody

export (PackedScene) var capsuleItem

var path = []
var path_node = 0
var speed = 9
onready var nav = get_parent().get_node("levelCont/Navigation")
onready var animPlayer = $playerCont/playerMeshCont/gorillaMesh/AnimationPlayer
onready var animPlayerDead = $playerCont/playerMeshCont/gorillaMesh/gorillaDeadAnim
onready var timer = $Timer
onready var hpTexture = $hpPanel/cont/Viewport/TextureProgress
onready var hpText = $hpPanel/cont/Viewport/Label
onready var hpBar = $hpPanel
onready var lookAtPos = Vector3.ZERO
onready var posArr = [Vector3(150, 0, 49),
					  Vector3(77, 0, -135),
					  Vector3(-103, 0, -141),
					  Vector3(-158, 0, 37)
]

onready var areaCol = $Area/CollisionShape
onready var capsuleCol = $capsuleArea/CollisionShape
onready var currentLookAtNum = 0
onready var tweenCapture = $moveWithCapsule
var dbug

func _ready():
	randomize()
	change_random_pos()
	set_physics_process(true)
	hpTexture.value = 100
	hpTexture.max_value = 100
	hpText.text = str(100)
	animPlayer.play("walk")
	capsuleCol.disabled = true

func _physics_process(delta):
	dbug = delta
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
	self.look_at(lookAtPos,Vector3.UP)

func change_random_pos():
	var randNum = floor(rand_range(0,posArr.size()))
	while randNum == currentLookAtNum:
		randNum = floor(rand_range(0,posArr.size()))
	currentLookAtNum = randNum
	lookAtPos = posArr[randNum]

func got_hit(damage):
	change_random_pos()
	animPlayer.play("run")
	hpBar.update_hp(damage)
	speed = 2
	yield(get_tree().create_timer(.2),"timeout")
	speed = 17

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(lookAtPos)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'remove':
		self.queue_free()

func play_dead():
	animPlayer.stop()
	animPlayerDead.play("gorillaDead")
	set_physics_process(false)
	timer.stop()
	GSignals.inst_hunt_chracter_after()
	$deadTimer.start()
	areaCol.disabled = true
	capsuleCol.disabled = false

func _on_deadTimer_timeout():
	animPlayer.play("remove")

func inst_capsule():
	$deadTimer.stop()
	GVariables.gorillaCount += 1
	var c  = capsuleItem.instance()
	add_child(c)
	capsuleCol.disabled = true
	yield(get_tree().create_timer(.8), "timeout")
	tween_capture_move()
	print(GVariables.gorillaCount)

func tween_capture_move():
	tweenCapture.interpolate_property(self, 'translation',self.translation, Vector3(0,20,320), 5,Tween.TRANS_LINEAR)
	tweenCapture.start()

func _on_moveWithCapsule_tween_completed(object, key):
	self.queue_free()
