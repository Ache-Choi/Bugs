extends RigidBody

export(String) var typeBugBall
export(Array, Color) var colPal

onready var animPlayer = $AnimationPlayer
onready var outline = $MeshInstance/MeshInstance

func _ready():
	animPlayer.play("instFadeOut")
	set_material()

func set_material():
	if typeBugBall == 'bugThrower1':
		var newMat = load("res://scenes/bugs/ballThrowing/bugBall.tres").duplicate()
		$MeshInstance.material_override = newMat
		outline.material_override.albedo_color = colPal[0]
		thower1_random_shots()
	elif typeBugBall == 'bugThrower2':
		var newMat = load("res://scenes/bugs/ballThrowing/bugBall2.tres").duplicate()
		$MeshInstance.material_override = newMat
		outline.material_override.albedo_color = colPal[1]

func thower1_random_shots():
	self.angular_velocity = Vector3(rand_range(-30,30),rand_range(-30,30),rand_range(-30,30))
	self.linear_velocity = Vector3(rand_range(-20,20),rand_range(15,25),rand_range(-20,20))

func thower2_random_shots(dir):
	self.angular_velocity = Vector3(rand_range(-30,30),rand_range(-30,30),rand_range(-30,30))
	self.linear_velocity = dir

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'instFadeOut':
		self.queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group('playerBody'):
		body.update_hp_bar(10)
		GSignals.inst_ball_explosion_particles(self.global_transform.origin)
		self.queue_free()
