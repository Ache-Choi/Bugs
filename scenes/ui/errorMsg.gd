extends Node2D

onready var textNameArr = ['noCoins', 'noCharacter']
onready var textArr  = ['Insufficient Coins', 'No character. Capture a character in Hunting Zone']
onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("instMsg")

func set_text(msgText):
	for i in textNameArr.size():
		if msgText == textNameArr[i]:
			$Label.text = textArr[i]
			return

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'instMsg':
		self.queue_free()
