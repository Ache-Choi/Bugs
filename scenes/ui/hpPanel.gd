extends Spatial

onready var hpText = $cont/Viewport/Label
onready var textProgress = $cont/Viewport/TextureProgress
onready var tween = $Tween

var bbbgg

func _ready():
	pass

func set_hp_text(numb):
	hpText.text = str(numb)

func update_hp(damagePts):
	var amountTo = textProgress.value - damagePts
	set_hp_text(amountTo)
	if amountTo < 0:
		amountTo = 0
	tween.interpolate_property(textProgress, 'value', textProgress.value, amountTo, .1, Tween.TRANS_QUAD,0)
	tween.start()
	var twoThirds = ((textProgress.max_value/3)*2)
	var third = textProgress.max_value/3
	if textProgress.value > twoThirds:
		textProgress.tint_progress = '00ff30'
	elif textProgress.value > third and textProgress.value <= twoThirds:
		textProgress.tint_progress = 'fff300'
	else:
		textProgress.tint_progress = 'ff0000'

func _on_Tween_tween_completed(object, key):
	if textProgress.value <= 0:
		if self.get_parent().name == 'gorillaPlayer' or self.get_parent().name == 'snakePlayer':
			print('playerDead')
		elif self.get_parent().is_in_group('huntingCharacter'):
			self.get_parent().play_dead()
		else:
			GSignals.inst_coin_mesh(self.global_transform.origin + Vector3(0,8,0))
			self.get_parent().queue_free()
	bbbgg = [object, key]
