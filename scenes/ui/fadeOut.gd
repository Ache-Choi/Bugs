extends Node2D

var fs

func _ready():
	$AnimationPlayer.play("fadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeOut':
		self.queue_free()

