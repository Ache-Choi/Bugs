extends Node2D

onready var imgNameArr = ['gorillaUp', 'gorillaDown','snakeUp', 'snakeDown']
onready var regionRectArr = [Rect2(628,6,249,262),Rect2(572,283,279,230),Rect2(897,6,374,262),Rect2(911,287,333,229)]
onready var animPlayer = $AnimationPlayer
onready var spr = $Sprite

func _ready():
	animPlayer.play("inst")

func set_img(imgName):
	for i in imgNameArr.size():
		if imgName == imgNameArr[i]:
			spr.region_rect = regionRectArr[i]
	if imgName == 'gorillaDown' or imgName == 'snakeDown':
		spr.position.y = 150
	else:
		spr.position.y = 0

func fade_out():
	animPlayer.play("fadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeOut':
		self.queue_free()
