extends Spatial

signal quit
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

# playerSceneArr[0] gorilla mesh , playerSceneArr[1] Snakemesh
export (Array, PackedScene) var characterSceneArr

export (PackedScene) var groundRocks
export (PackedScene) var shipBulletParticles
export (PackedScene) var shipBullet
export (PackedScene) var capsuleBullet
export (PackedScene) var fadeFx

onready var cam = $camLight/Camera
onready var ray = $camLight/Camera/RayCast
onready var cursor
onready var canShoot = true
onready var canShootTimer = $shootCooldown
onready var huntingCharacterPosArr = [Vector3(-161,0,-32), Vector3(150,0,-22), Vector3(21,0,-140), Vector3(-61,0,-140)]
onready var newHuntingArr = []
var dBug
#inst  hunting characters after dead#
#capsule

func _ready():
	randomize()
	dBug = GSignals.connect('instBugBall', self, 'inst_bug_ball')
	dBug = GSignals.connect('instGroundRocks', self, 'inst_ground_rocks')
	dBug = GSignals.connect('instShipBulletParticles', self, 'inst_ship_bullet_explosion')
	dBug = GSignals.connect('changeScene', self, 'change_scene')
	dBug = GSignals.connect('instHuntingChar', self, 'inst_hunting_char_after')
	cam.set_target($playerShip/camFollow)
	newHuntingArr = GFuncs.shuffle_position_arr(huntingCharacterPosArr)
	inst_hunting_characters(floor(rand_range(0,10)),newHuntingArr[0])
	inst_hunting_characters(floor(rand_range(0,10)),newHuntingArr[1])

func inst_hunting_characters(randNum, pos):
	var charNum = 0
	if randNum < 7:
		charNum = 0
	else:
		charNum = 1
	var g = characterSceneArr[charNum].instance()
	g.translation = pos
	add_child(g)

func inst_hunting_char_after():
	var randNum = floor(rand_range(0,10))
	var charNum
	if randNum < 7:
		charNum = 0
	else:
		charNum = 1
	var g = characterSceneArr[charNum].instance()
	g.translation = huntingCharacterPosArr[floor(rand_range(0,huntingCharacterPosArr.size()))]
	add_child(g)

func inst_ground_rocks(pos):
	var randNum = floor(rand_range(4,8))
	for i in randNum:
		var r = groundRocks.instance()
		r.translation = pos
		add_child(r)

func inst_ship_bullet_explosion(pos):
	var p = shipBulletParticles.instance()
	p.translation = pos
	add_child(p)

func change_scene():
	var path = GVariables.nextScenePath
	emit_signal("replace_main_scene", ResourceLoader.load(path))

var toggleNum = 0

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
			var from =  $playerShip/playerCont/playerMeshCont/airAttackPos.global_transform.origin
			if canShoot:
				canShoot = false
				canShootTimer.start()
				ship_bullet(from,cursor)
				GSignals.player_ship_shoot()
#			GSignals.ship_attack(get_rotation())
#			print(get_rotation(), '  ', toPos)
	if Input.is_action_just_pressed("rightClick"):
		if ray.is_colliding():
			var from = Vector3.ZERO
			if toggleNum == 0:
				from = $playerShip/playerCont/playerMeshCont/capsuleShootPos1.global_transform.origin
			else:
				from = $playerShip/playerCont/playerMeshCont/capsuleShootPos2.global_transform.origin
			if canShoot:
				canShoot = false
				canShootTimer.start()
				capsule_bullet(from,cursor)
	dBug = delta

func get_rotation():
	var playerCenterPos = $playerShip/playerCont/.global_transform.origin
	var dir = cursor - playerCenterPos
	var rotDegrees = GFuncs.convert_to_degrees(Vector2(dir.normalized().x,dir.normalized().z))
	return rotDegrees

func ship_bullet(pos,to):
	var s = shipBullet.instance()
	s.translation = pos
	add_child(s)
	s.tween_shoot(pos, to)

func capsule_bullet(pos, to):
	var c = capsuleBullet.instance()
	c.translation = pos
	add_child(c)
	c.tween_shoot(pos, to)

func _on_shootCooldown_timeout():
	if toggleNum == 0:
		toggleNum = 1
	else:
		toggleNum = 0
	canShoot = true

func inst_fade_fx():
	var f = fadeFx.instance()
	add_child(f)

func _on_exitArea_body_entered(body):
	if body.is_in_group('playerBody'):
		GVariables.nextScenePath = 'res://scenes/ui/startPage.tscn'
		inst_fade_fx()

func _on_Area_area_entered(area):
	if area.is_in_group('huntingCharacter'):
		area.get_parent().change_random_pos()
