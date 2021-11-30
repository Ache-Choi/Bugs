extends Control

onready var animPlayer = $AnimationPlayer
onready var missionText = $container/missionText
onready var scoreNeeded = $container/scoreNeeded
onready var scorePoints = $container/yourScorePoints
onready var goTo = ''
var ddb

func _ready():
#	SaveLoad.save_data()
	animPlayer.play("inst")
	GSignals.stop_spawns()
	set_result()

func set_result():
#	if GVariables.playerScore >= 150 +(GVariables.currentLevel*150):
#		missionText.text = 'Level ' + str(GVariables.currentLevel) + ' complete'
#		scoreNeeded.text = 'needed ' + str(150 +(GVariables.currentLevel*150))
#		if GVariables.currentLevel-1 == GVariables.scorePerLevelArr.size():
#			GVariables.scorePerLevelArr.append(GVariables.playerScore)
#		else:
#			if GVariables.playerScore > GVariables.scorePerLevelArr[GVariables.currentLevel-1]:
#				GVariables.scorePerLevelArr[GVariables.currentLevel-1] = GVariables.playerScore
#		if GVariables.currentLevel == 8:
#			GVariables.currentLevel = 1
#		else:
#			GVariables.currentLevel += 1
#		scorePoints.text = str(GVariables.playerScore)
#		GVariables.playerScore = 0
#	else:
#		missionText.text = 'Level ' + str(GVariables.currentLevel) + ' incomplete'
#		scorePoints.text = str(GVariables.playerScore)
#		scoreNeeded.text = 'needed '+str(GVariables.scoreNeeded)
#		GVariables.playerScore = 0
	scorePoints.text = str(GVariables.score)
#	GVariables.scoreNeeded = 150+(150*GVariables.currentLevel)

func _on_nextBtn_button_up():
	GSignals.inst_sounds('click')
	goTo = 'next'
	animPlayer.play("close")

func _on_homeBtn_button_up():
	GSignals.inst_sounds('click')
	goTo = 'home'
	animPlayer.play("close")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close' and goTo == 'home':
		GVariables.playerLives = 3
		GVariables.weaponAcquiredArr[0] = 0
		GVariables.boltNuts = 0
		GVariables.score = 0
		GVariables.skipStartPage = false
		ddb = get_tree().change_scene('res://scenes/main.tscn')
	if anim_name == 'close' and goTo == 'next':
		GVariables.playerLives = 3
		GVariables.weaponAcquiredArr[0] = 0
		GVariables.boltNuts = 0
		GVariables.score = 0
		GVariables.skipStartPage = true
		ddb = get_tree().change_scene('res://scenes/main.tscn')
