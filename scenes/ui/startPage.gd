extends Control

var res_loader : ResourceInteractiveLoader = null
var loading_thread : Thread = null

signal quit
#warning-ignore:unused_signal
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

export (PackedScene) var errMsg
onready var ui = $Control
onready var loading = ui.get_node("Loading")
onready var loading_progress = loading.get_node("ProgressBar")
onready var loading_done_timer = loading.get_node("Timer")

onready var animPlayer = $AnimationPlayer
onready var coinCount = $coinInfo/coinCount
onready var hlCont = $HLCont
onready var btnCont = $btnContainer
onready var levelNameArr = ['level1', 'level2', 'level3', 'huntingZone', 'lab']
var dbug

func _ready():
	animPlayer.play("setPlay")
	set_info()
	set_level_btns()
	set_hl(GVariables.currentLevel)

func set_info():
	coinCount.text = str('x ',GVariables.coinCount)

func set_level_btns():
	if GVariables.levelCompleted == 0:
		btnCont.get_node("level2").hide()
		btnCont.get_node("level3").hide()
	if GVariables.levelCompleted == 1:
		hlCont.get_node("level2blackOut").hide()
		btnCont.get_node("level2").show()
		btnCont.get_node("level3").hide()
	if GVariables.levelCompleted == 2:
		hlCont.get_node("level3blackOut").hide()
		btnCont.get_node("level3").show()

func set_hl(hlNum): 
	for i in 5:
		hlCont.get_child(i).hide()
	hlCont.get_child(hlNum).show()

func loading_done(loader):
	loading_thread.wait_to_finish()
	emit_signal("replace_main_scene", loader.get_resource())
	res_loader = null

func _on_Timer_timeout():
	loading_done(res_loader)

func _on_play_button_down():
	
#	if GVariables.soundOnOff:
#		GSignals.inst_sounds('click')
	if GVariables.playerChosenNum >= 0 or GVariables.currentLevel >= 3:
		animPlayer.play("playBtn")
		loading.show()
		var path = GVariables.nextScenePath
		if ResourceLoader.has_cached(path):
			emit_signal("replace_main_scene", ResourceLoader.load(path))
		else:
			res_loader = ResourceLoader.load_interactive(path)
			loading_thread = Thread.new()
			#warning-ignore:return_value_discarded
			loading_thread.start(self, "interactive_load", res_loader)
	else:
		inst_err_msg('noCharacter')

func interactive_load(loader):
	while true:
		var status = loader.poll()
		if status == OK:
#			loading_progress.value = (loader.get_stage() * 100) / loader.get_stage_count()
#			print(loader.get_stage() * 100)
			continue
		elif status == ERR_FILE_EOF:
			loading_progress.value = 100
			loading_done_timer.start()
#			print(loader.get_stage() * 100, '     -----   ', loading_progress.value )
			break
		else:
			print("Error while loading level: " + str(status))
			loading.hide()
			break

func _on_settings_button_up():
#	if GVariables.soundOnOff:
#		GSignals.inst_sounds('click')
	var s = load('res://scenes/ui/settings.tscn').instance()
	add_child(s)
	
func _on_Button_button_down():
	get_tree().quit()

func _on_info_button_up():
	animPlayer.play("infoPanel")

func _on_closeInfo_button_down():
	animPlayer.play_backwards("infoPanel")

func _on_level1_button_down():
	GVariables.currentLevel = 0
	set_hl(GVariables.currentLevel)
	GVariables.nextScenePath = 'res://scenes/levels/levelScene/level1.tscn'

func _on_level2_button_down():
	GVariables.currentLevel = 1
	set_hl(GVariables.currentLevel)
	GVariables.nextScenePath = 'res://scenes/levels/levelScene/level2.tscn'

func _on_level3_button_down():
	GVariables.currentLevel = 2
	set_hl(GVariables.currentLevel)
	GVariables.nextScenePath = 'res://scenes/levels/levelScene/level3.tscn'

func _on_huntingZone_button_down():
	GVariables.currentLevel = 3
	set_hl(GVariables.currentLevel)
	GVariables.nextScenePath = 'res://scenes/levels/huntingZone/huntingZone.tscn'

func _on_lab_button_down():
	GVariables.currentLevel = 4
	set_hl(GVariables.currentLevel)
	GVariables.nextScenePath = 'res://scenes/ui/labScene.tscn'

func inst_err_msg(textType):
	var m = errMsg.instance()
	add_child(m)
	m.set_text(textType)


func _on_AnimationPlayer_animation_finished(anim_name):
	dbug = anim_name
