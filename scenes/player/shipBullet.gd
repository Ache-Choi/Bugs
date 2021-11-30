extends Spatial

onready var tween = $Tween
onready var lastPos = Vector3.ZERO

func _ready():
	pass # Replace with function body.

func tween_shoot(from, to):
	lastPos = to
	tween.interpolate_property(self, 'translation',from, to, 0.2,Tween.TRANS_LINEAR)
	tween.start()

func _on_Area_body_entered(body):
	if body.is_in_group('staticForBullet'):
		GSignals.inst_ship_bullet_particles(lastPos)


func _on_Tween_tween_completed(object, key):
	GSignals.inst_ship_bullet_particles(lastPos)
	self.queue_free()

func _on_Area_area_entered(area):
	if area.is_in_group('huntingCharacter'):
		area.get_parent().got_hit(20)
		GSignals.inst_ship_bullet_particles(self.global_transform.origin)
		self.queue_free()
