extends Control

onready var goTo = 'resume'
var dBug

func _ready():
	$AnimationPlayer.play("insert")

func _on_resume_button_up():
	goTo = 'resume'
	$AnimationPlayer.play("close")

func _on_home_button_up():
	goTo = 'home'
	$AnimationPlayer.play("close")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close' and goTo == 'home':
		get_tree().paused = not get_tree().paused
		dBug = get_tree().change_scene('res://scenes/ui/startPage.tscn')
		self.queue_free()
	if anim_name == 'close' and goTo == 'resume':
		get_tree().paused = not get_tree().paused
		self.queue_free()

