extends Node

export (String) var soundName
export (int) var volu

onready var audioSt = $AudioStreamPlayer

onready var soundPlayerArr = [
						'res://assets/soundMusic/sounds/cancelSound.wav',
						'res://assets/soundMusic/sounds/coin.wav',
						'res://assets/soundMusic/sounds/explosion.wav'
]

onready var soundPlayerArrName = [
						'cancel',
						'coin',
						'rocketFire'
]

func _ready():
	audioSt.connect('finished', self, '_on_AudioStreamPlayer_finished')
	self.set_player_audio(soundName)

func set_player_audio(soundNamee):
	var path
	for i in soundPlayerArrName.size():
		if soundNamee == soundPlayerArrName[i]:
			path = soundPlayerArr[i]

	audioSt.stream = load(path)

	if soundName == 'level2boss':
		audioSt.volume_db = 0
		audioSt.pitch_scale = 1.3
	elif soundName == 'laser':
		audioSt.volume_db = 9
		audioSt.pitch_scale = 1.3
	elif soundName == 'snapExplosion':
		audioSt.volume_db = -7
		audioSt.pitch_scale = 1.5

	audioSt.play()

func _on_AudioStreamPlayer_finished():
	self.queue_free()
