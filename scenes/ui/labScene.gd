extends Control
signal quit
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

export (PackedScene) var errMsg
export (PackedScene) var characterImgScene

onready var tween = $Tween
onready var iconHl = $hl
onready var characterName = $panelCont/name
onready var level = $panelCont/levelText
onready var hpAmount = $panelCont/hpAmount
onready var attackDamage = $panelCont/attackDamage
onready var descrip = $panelCont/descrip

onready var gorillaDescription = 'ground smash \nair smash'
onready var snakeDescription = 'ground freeze, swipe \nair whip'

onready var gorillaCount = $gorillaIcon/gorillaCount
onready var snakeCount = $snakeIcon/snakeCount
onready var coin = $coinCount

onready var gorillaIcon = $gorillaIcon
onready var snakeIcon = $snakeIcon

onready var characterImgCont = $characterImgCont
var dBug

func _ready():
	dBug = GSignals.connect('updateLabCounts', self, 'set_counts')
	inst_character_img()
	set_hl_img()
	set_icon()
	update_info(GVariables.playerChosenNum)
	set_counts()

#onready var imgNameArr = ['gorillaUp', 'gorillaDown', 'snakeDown', 'snakeUp']
func inst_character_img():
	if GVariables.playerChosenNum == 0:
		if GVariables.gorillaCount > 0:
			var c = characterImgScene.instance()
			characterImgCont.add_child(c)
			if GVariables.gorillaLevel > 0:
				c.set_img('gorillaUp')
			else:
				c.set_img('gorillaDown')
	elif GVariables.playerChosenNum == 1:
		if GVariables.snakeCount > 0:
			var c = characterImgScene.instance()
			characterImgCont.add_child(c)
			if GVariables.snakeLevel > 0:
				c.set_img('snakeUp')
			else:
				c.set_img('snakeDown')

func change_scene():
	var path = GVariables.nextScenePath
#	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("replace_main_scene", ResourceLoader.load(path))

func set_hl_img():
	if GVariables.playerChosenNum == 0:
		iconHl.position = Vector2(190,480)
	elif GVariables.playerChosenNum == 1:
		iconHl.position = Vector2(190,625)
	else:
		iconHl.hide()

func set_icon():
	if GVariables.gorillaCount > 0:
		gorillaIcon.show()
	else:
		gorillaIcon.hide()
	if GVariables.snakeCount > 0:
		snakeIcon.show()
	else:
		snakeIcon.hide()

func update_info(typenum):
	if typenum -1:
		characterName.text = '---------'
		level.text = '-'
		hpAmount.text = '-'
		attackDamage.text = '-'
		descrip.text ='-'
	if typenum == 0 and GVariables.gorillaLevel > 0:
		characterName.text = 'gorilla stone'
		level.text = str(GVariables.gorillaLevel)
		hpAmount.text = str(GVariables.gorillaHP, ' / ', (100+((GVariables.gorillaLevel-1)* 10)))
		attackDamage.text = str(GVariables.attackDamage + ((GVariables.gorillaLevel-1)*5))
		descrip.text = gorillaDescription
	if typenum == 1 and GVariables.snakeLevel > 0:
		characterName.text = 'snake stone'
		level.text = str(GVariables.snakeLevel)
		hpAmount.text = str(GVariables.snakeHP, ' / ', (100+((GVariables.snakeLevel-1) * 10)))
		attackDamage.text = str(GVariables.attackDamage + ((GVariables.snakeLevel-1)*5))
		descrip.text = snakeDescription

func set_counts():
	gorillaCount.text = str('x ',GVariables.gorillaCount)
	snakeCount.text = str('x ',GVariables.snakeCount)
	coin.text = str('x ',GVariables.coinCount)

func _on_gorillaStone_button_down():
	if iconHl.position != Vector2(190,480):
		tween_move(iconHl.position, Vector2(190,480))
		GVariables.playerChosenNum = 0
		update_info(GVariables.playerChosenNum)
		characterImgCont.get_child(0).fade_out()
		inst_character_img()

func _on_snakeStone_button_down():
	if iconHl.position != Vector2(190,625):
		tween_move(iconHl.position, Vector2(190,625))
		GVariables.playerChosenNum = 1
		update_info(GVariables.playerChosenNum)
		characterImgCont.get_child(0).fade_out()
		inst_character_img()

func tween_move(from, to):
	tween.interpolate_property(iconHl, 'position',from, to, .1,Tween.TRANS_LINEAR)
	tween.start()

func _on_upgrade_button_down():
	if GVariables.coinCount >= 20:
		if GVariables.playerChosenNum == 0:
			GVariables.coinCount -= 20
			set_counts()
			if GVariables.gorillaLevel == 0:
				characterImgCont.get_child(0).fade_out()
				GVariables.gorillaLevel += 1
				inst_character_img()
			else:
				GVariables.gorillaLevel += 1
			GVariables.gorillaMaxHP = (100+((GVariables.gorillaLevel-1)* 10))
			GVariables.gorillaHP = (100+((GVariables.gorillaLevel-1)* 10))
			update_info(GVariables.playerChosenNum)

		if GVariables.playerChosenNum == 1:
			GVariables.coinCount -= 20
			set_counts()
			if GVariables.snakeLevel == 0:
				characterImgCont.get_child(0).fade_out()
				GVariables.snakeLevel += 1
				inst_character_img()
			else:
				GVariables.snakeLevel += 1
			GVariables.snakeMaxHP = (100+((GVariables.snakeLevel-1)* 10))
			GVariables.snakeHP = (100+((GVariables.snakeLevel-1)* 10))
			update_info(GVariables.playerChosenNum)
		if GVariables.playerChosenNum == -1:
			inst_err_msg('noCharacter')
	else:
		inst_err_msg('noCoins')


func inst_err_msg(textType):
	var m = errMsg.instance()
	add_child(m)
	m.set_text(textType)

func _on_done_button_down():
	GVariables.nextScenePath = 'res://scenes/ui/startPage.tscn'
	change_scene()
