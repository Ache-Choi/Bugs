extends InterpolatedCamera

onready var animPlayer = $AnimationPlayer
var dBug

func _ready():
	dBug = GSignals.connect('camShake', self, 'cam_shake')

func cam_shake():
	animPlayer.play("camShake")
