extends Spatial

signal quit
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

# playerSceneArr[0] gorilla mesh , playerSceneArr[1] Snakemesh
export (Array, PackedScene) var playerSceneArr

export (PackedScene) var gorillaGroundFx
export (PackedScene) var groundRocks
export (PackedScene) var ballExplosionParticles
export (PackedScene) var ballThrowerBall
export (PackedScene) var gorillaGroundFxGloves
export (PackedScene) var coinScene
export (PackedScene) var numCount

onready var cam = $camLight/Camera
onready var ray = $camLight/Camera/RayCast
onready var cursor
onready var playerCont = $playerCont
var dBug

func _ready():
	dBug = GSignals.connect('groundAttackGorillaFX', self, 'inst_gorilla_attack_fx')
	dBug = GSignals.connect('instBugBall', self, 'inst_bug_ball')
	dBug = GSignals.connect('instBallExplosionParticles', self, 'inst_explosion_particles')
	dBug = GSignals.connect('instGroundRocks', self, 'inst_ground_rocks')
	dBug = GSignals.connect('instCoinGem', self, 'inst_coin_gem')
	dBug = GSignals.connect('instCountText', self, 'inst_count_text')
	inst_player(GVariables.playerChosenNum)
	if GVariables.playerChosenNum == 0:
		cam.set_target($playerCont/gorillaPlayer/camFollow)
	elif GVariables.playerChosenNum == 1:
		cam.set_target($playerCont/snakePlayer/camFollow)

func inst_count_text(pos):
	var p = numCount.instance()
	p.translation = pos
	add_child(p)

func inst_coin_gem(pos):
	var c = coinScene.instance()
	c.translation = pos
	add_child(c)

func inst_player(typePlayer):
	var g = playerSceneArr[typePlayer].instance()
	g.translation = Vector3(0,0,0)
	playerCont.add_child(g)

func inst_gorilla_attack_fx(type, pos, rotY):
	if type == 'noGloves':
		var f = gorillaGroundFx.instance()
		f.translation = pos
		f.rotation_degrees.y = rotY
		add_child(f)

func inst_ground_rocks(pos):
	var randNum = floor(rand_range(4,8))
	for i in randNum:
		var r = groundRocks.instance()
		r.translation = pos
		add_child(r)

func inst_explosion_particles(pos):
	var p = ballExplosionParticles.instance()
	p.translation = pos
	add_child(p)

func inst_bug_ball(pos, count, type, to):
	if type == 'bugThrower1':
		for i in count:
			var b = ballThrowerBall.instance()
			b.translation = pos
			b.typeBugBall = type
			yield(get_tree().create_timer(.1), "timeout")
			add_child(b)
	elif type == 'bugThrower2':
		for i in count:
			var b = ballThrowerBall.instance()
			b.translation = pos
			b.typeBugBall = type
			yield(get_tree().create_timer(.1), "timeout")
			add_child(b)
			b.thower2_random_shots((to-pos).normalized()* 50)

func change_scene():
	var path = GVariables.nextScenePath
#	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("replace_main_scene", ResourceLoader.load(path))

func _process(delta):
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var to = cam.project_local_ray_normal(mouse_pos) * ray_length
	ray.cast_to = to
	ray.force_raycast_update()
	if ray.is_colliding():
		cursor = ray.get_collision_point() * Vector3(1,1,1)

	if Input.is_action_just_pressed("leftClick"):
		if ray.is_colliding():
			var from =  $playerCont.get_child(0).global_transform.origin
			var toPos = Vector3(cursor.x,0,cursor.z) - from
			GSignals.player_attack(get_rotation())
#			print(get_rotation(), '  ', toPos)
	
	dBug = delta

func get_rotation():
	var playerCenterPos = $playerCont.get_child(0).global_transform.origin
	var dir = cursor - playerCenterPos
	var rotDegrees = GFuncs.convert_to_degrees(Vector2(dir.normalized().x,dir.normalized().z))
	return rotDegrees

func _on_level2Area_body_entered(body):
	if body.is_in_group('playerBody'):
		print('go to next level')

#func _on_bug1Area_body_entered(body):
#	if body.is_in_group('playerBody'):
#		pass
