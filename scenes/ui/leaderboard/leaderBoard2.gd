extends Control

export (String) var lbType

onready var vBoxContainer = $container/MarginContainer/VBoxContainer
onready var hBox = $container/MarginContainer/VBoxContainer/HBoxContainer
onready var animPlayer = $AnimationPlayer
onready var scoreText = $container/Label

func _ready():
	if lbType == 'mars':
		scoreText.text = 'distance (mts.)'
	else:
		scoreText.text = 'best time (sec.)'
		
	animPlayer.play("insert")
	set_horizontal_lines(7)
	
#	if lbType != 'mars':
#		yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received")
#	#	print(SilentWolf.Scores.scores.size())
#		yield(SilentWolf.Scores.get_high_scores(SilentWolf.Scores.scores.size()), "sw_scores_received")
#		SilentWolf.Scores.scores.invert()
#	else:
#		yield(SilentWolf.Scores.get_high_scores(8), "sw_scores_received")
#	set_text()


func set_horizontal_lines(count):
	for i in count:
		var oneLine = hBox.duplicate()
		oneLine.get_node('pos').text = str(i+2)
		vBoxContainer.add_child(oneLine)
		
func set_text():
	pass
#	print(SilentWolf.Scores.scores.size())
#	if SilentWolf.Scores.scores.size() >= 8:
#		for i in 8:
#			vBoxContainer.get_child(i).get_node('name').text = str(SilentWolf.Scores.scores[i]['player_name'])
#			vBoxContainer.get_child(i).get_node('score').text = str(SilentWolf.Scores.scores[i]['score'])
#	elif SilentWolf.Scores.scores.size() > 0 and SilentWolf.Scores.scores.size() < 8:
#		for i in SilentWolf.Scores.scores.size():
#			vBoxContainer.get_child(i).get_node('name').text = str(SilentWolf.Scores.scores[i]['player_name'])
#			vBoxContainer.get_child(i).get_node('score').text = str(SilentWolf.Scores.scores[i]['score'])
		
#	for i in SilentWolf.Scores.scores.size():
#		vBoxContainer.get_child(i).get_node('name').text = str(SilentWolf.Scores.scores[i]['player_name'])
#		vBoxContainer.get_child(i).get_node('score').text = str(SilentWolf.Scores.scores[i]['score'])

func _on_closeBtn_button_down():
	animPlayer.play("close")
	GSignals.inst_sounds('cancel')

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'close':
		self.queue_free()
