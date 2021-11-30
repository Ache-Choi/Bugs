extends RigidBody

export(String) var rigidStatic
onready var animPlayer = $AnimationPlayer
onready var coinMesh = $coin2
onready var tween = $Tween

func _ready():
	set_material()
	pop_up()
	if rigidStatic == 'static':
		self.mode = 1
		animPlayer.play("rotate")
		$CollisionShape.disabled = true

func pop_up():
	self.angular_velocity = Vector3(rand_range(-30,30),rand_range(-30,30),rand_range(-30,30))
	self.linear_velocity = Vector3(rand_range(-10,10),rand_range(15,25),rand_range(-10,10))

func set_material():
	var newMat = load("res://scenes/ui/itemMesh/coinMaterial.tres").duplicate()
	coinMesh.material_override = newMat

func _on_Area_body_entered(body):
	if body.is_in_group('playerBody'):
		GSignals.inst_count_text_mesh(body.global_transform.origin + Vector3(0,7,0))
		GVariables.coinCount += 1
		GSignals.update_coin_count()
		self.queue_free()

func tween_move(from, to):
	tween.interpolate_property(self, 'translation',from, to, .2,Tween.TRANS_QUAD)
	tween.start()

func _on_magnetArea_body_entered(body):
	if body.is_in_group('playerBody'):
		tween_move(self.global_transform.origin, GVariables.playerPos)

func _on_Tween_tween_completed(object, key):
	self.queue_free()

