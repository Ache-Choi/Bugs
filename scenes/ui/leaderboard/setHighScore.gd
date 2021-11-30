extends Control
export (String) var type

onready var editNameText = $container/LineEdit
onready var animPlayer = $AnimationPlayer
onready var mobileAnimPlayer = $container/forMobile/AnimationPlayer
onready var mobileLineEdit = $container/forMobile/LineEdit
onready var nameLabel = $container/nameEnterLabel
onready var saveBtn = $container/Button
var player_name
var score
var dBug

func _ready():
	animPlayer.play("insert")

# this section is for pc
#func _on_Button_button_down():
#	gSignals.inst_sound('btnClick',false,0)
#	$container/Button.disabled = true
#	if editNameText.text == '':
#		player_name = 'No Name'
#		score = gVars.playerScore
#	else:
#		player_name = str(editNameText.text)
#		score = gVars.playerScore
#	$container/Label2.text = 'Saving...'
#	var score_id = yield(SilentWolf.Scores.persist_score(player_name, score), "sw_score_posted")
#	animPlayer.play("close")
#	if get_parent().has_method('btns_disabled'):
#		get_parent().btns_disabled(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close':
		self.queue_free()

# this section is for mobile
func _on_Button_button_down():
	saveBtn.disabled = true
	if type == 'time':
		score = GVariables.scoreTime
	elif type == 'distance':
		score = GVariables.farthestDist
	if nameLabel.text == '':
		player_name = 'No Name'
	else:
		player_name = str(nameLabel.text)
	$container/Label2.text = 'Saving...'
#	var score_id = yield(SilentWolf.Scores.persist_score(player_name, score), "sw_score_posted")
	animPlayer.play("close")

func _on_forMobile2_button_down():
	mobileLineEdit.grab_focus()
	mobileAnimPlayer.play("inst")

func _on_doneBtn_button_down():
	mobileAnimPlayer.play_backwards("inst")
	dBug = OS.hide_virtual_keyboard()
	nameLabel.text = str(mobileLineEdit.text)



