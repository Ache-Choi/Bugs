extends Spatial

onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("capsuleAnim")

