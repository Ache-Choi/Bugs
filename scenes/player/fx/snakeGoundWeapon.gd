extends Spatial

onready var animPlayer = $AnimationPlayer
onready var cicleFX = $circlFX
onready var col = $hitArea/CollisionShape
var dbug

func _ready():
	set_material()
	$meshFX.hide()
	yield(get_tree().create_timer(.3), "timeout")
	$meshFX.show()
	animPlayer.play("groundBreak")
	cicleFX.animPlayer.play('instFadeOut')
	$areaColTimer.start()
	GSignals.inst_ground_rocks($circlFX.global_transform.origin)

func set_material():
	var newMat = load("res://scenes/player/fx/gorillaGroundFX.tres").duplicate()
	$meshFX.material_override = newMat

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'groundBreak':
		self.queue_free()

func _on_hitArea_area_entered(area):
	if area.is_in_group('bugs'):
		col.disabled = true
		print(area.name)

func _on_areaColTimer_timeout():
	$hitArea/CollisionShape.disabled = true
