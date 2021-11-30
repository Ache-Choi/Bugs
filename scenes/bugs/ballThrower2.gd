extends KinematicBody

var path = []
var path_node = 0
var speed = 8
onready var nav = get_parent().get_node("levelCont/Navigation")
onready var animPlayer = $ballBug2/AnimationPlayer
onready var timer = $Timer
onready var bugPos = Vector3.ZERO
onready var hpTexture = $hpPanel/cont/Viewport/TextureProgress
onready var hpText = $hpPanel/cont/Viewport/Label
onready var hpBar = $hpPanel
onready var tween1 = $Tween
onready var lookAt = 'bugPos1'
onready var inArea = false
onready var syncShootTimer = $shootBallWaitTimer
onready var shootTopos = Vector3.ZERO
var dbug

func _ready():
	set_physics_process(false)
	bugPos = self.global_transform.origin
	hpTexture.value = GVariables.bugsHP['ballThrower2']
	hpTexture.max_value = GVariables.bugsHP['ballThrower2']
	hpText.text = str(GVariables.bugsHP['ballThrower2'])

func _physics_process(delta):
	dbug = delta
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
	if lookAt == 'bugPos':
		self.look_at(bugPos,Vector3.UP)
	else:
		self.look_at(Vector3(GVariables.playerPos.x,0,GVariables.playerPos.z),Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
#	move_to(Vector3(GVariables.playerPos.x,0,GVariables.playerPos.z))
	if GVariables.playerPos.z < (bugPos.z +100):
		lookAt = 'player'
		move_to(Vector3(GVariables.playerPos.x,0,GVariables.playerPos.z))
		if inArea == false:
			inArea = true
			set_physics_process(true)
	else: 
		inArea = false
		lookAt = 'bugPos'
		animPlayer.play("walk")
		move_to(bugPos)

func _on_bugArea2_body_entered(body):
	if body.is_in_group('playerBody'):
		animPlayer.stop()
		animPlayer.playback_speed = 1.8
		animPlayer.play("shoot")
		syncShootTimer.start()
		set_physics_process(false)
		shootTopos = GVariables.playerPos

func _on_bugArea2_body_exited(body):
	if body.is_in_group('playerBody'):
		animPlayer.playback_speed = 1
		animPlayer.play("walk")
		$shootTimer.stop()
		set_physics_process(true)
		shootTopos


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'shoot':
		$shootTimer.start()

func _on_shootTimer_timeout():
	animPlayer.play("shoot")
	set_physics_process(false)
	syncShootTimer.start()

func _on_bugArea_area_entered(area):
	if area.is_in_group('gorillaAttack'):
		hpBar.update_hp(20)
		animPlayer.play("gotHit")
		var newPos = -((GVariables.playerPos - self.global_transform.origin)*0.7)
		tween_move_back(self.global_transform.origin, 
							Vector3(self.global_transform.origin.x + newPos.x,
							self.global_transform.origin.y,
							self.global_transform.origin.z + newPos.z))

func tween_move_back(from, to):
	set_physics_process(false)
	tween1.interpolate_property(self, 'translation',from, to, 0.1,Tween.TRANS_QUAD)
	tween1.start()

func _on_Tween_tween_completed(object, key):
#	set_physics_process(true)
	dbug = [object, key]


func _on_shootBallWaitTimer_timeout():
	GSignals.inst_bug_balls($shootPos.global_transform.origin, floor(rand_range(1,5)), 'bugThrower2', shootTopos)
