extends RigidBody

onready var tween = $Tween
onready var rockMesh = $rockMeshCont/rockMesh
onready var col = $CollisionShape

func _ready():
	$Timer.start()
	velocity_set()
	set_rand_sizes()

func set_rand_sizes():
	var randSize = Vector3(rand_range(0.2, .8),rand_range(0.2, .8),rand_range(0.2, .8))
	rockMesh.scale = randSize
	col.shape.radius = randSize.x

func velocity_set():
	self.angular_velocity = Vector3(rand_range(-30,30),rand_range(-30,30),rand_range(-30,30))
	self.linear_velocity = Vector3(rand_range(-20,20),rand_range(10,30),rand_range(-20,20))

func tween_self_remove(from,to):
	tween.interpolate_property($rockMeshCont,'scale',from,to, .5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()

func _on_Timer_timeout():
	tween_self_remove($rockMeshCont.scale,Vector3(0.01,0.01,0.01))

func _on_Tween_tween_completed(object, key):
	self.queue_free()
