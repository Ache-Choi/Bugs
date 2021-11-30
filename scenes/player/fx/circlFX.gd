extends Spatial

onready var animPlayer = $AnimationPlayer
var dbug

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'instFadeOut':
		self.queue_free()



