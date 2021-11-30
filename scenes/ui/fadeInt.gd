extends Node2D

export (String) var animeName
var ddb

func _ready():
	$AnimationPlayer.play("fadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeIn':
		GSignals.g_change_scene()

func _on_Timer_timeout():
	self.queue_free()
