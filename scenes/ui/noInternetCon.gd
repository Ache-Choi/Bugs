extends Node

func _ready():
	$AnimationPlayer.play("wifiBlink")

func _on_quitBtn_button_down():
	get_tree().quit()
