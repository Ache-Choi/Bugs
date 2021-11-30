extends Node2D


func _ready():
	update_info()

func update_info():
	if GVariables.gorillaCount > 1:
		self.show()
	else:
		self.hide()

func _on_sell_button_down():
	GVariables.gorillaCount -= 1
	GVariables.coinCount += 10
	update_info()
	GSignals.update_lab_counts()
	
