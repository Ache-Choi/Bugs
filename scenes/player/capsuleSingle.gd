extends Spatial

onready var tween = $Tween
onready var lastPos = Vector3.ZERO
onready var firstPos = Vector3.ZERO
var dbug
func _ready():
	pass # Replace with function body.

func tween_shoot(from, to):
	firstPos = from
	lastPos = to
	tween.interpolate_property(self, 'translation',from, to, 0.5,Tween.TRANS_LINEAR)
	tween.start()

func _on_Tween_tween_completed(object, key):
	self.queue_free()
	dbug = [object, key]

func _on_capsuleBulletArea_area_entered(area):
	if area.is_in_group('huntingCharacter'):
		area.get_parent().inst_capsule()
		self.queue_free()
		
