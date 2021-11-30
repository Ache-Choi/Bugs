extends Spatial

onready var animPlayer = $AnimationPlayer
onready var cicleFX = $circlFX
onready var col = $hitArea/CollisionShape
var dbug

func _ready():
	$areaColTimer.start()
	GSignals.inst_ground_rocks($circlFX.global_transform.origin)
	GSignals.inst_ground_rocks($circlFX.global_transform.origin+Vector3(0,0,-10))


func _on_hitArea_area_entered(area):
	if area.is_in_group('bugs'):
		col.disabled = true


func _on_areaColTimer_timeout():
	$hitArea/CollisionShape.disabled = true
