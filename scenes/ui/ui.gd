extends Control

#onready var timer = $Timer
onready var animPlayer = $AnimationPlayer
onready var coinCount = $coinCount

var dbug

func _ready():
	dbug = GSignals.connect('updateCoins', self, 'update_coins')
	update_coins()

func update_coins():
	coinCount.text = str(GVariables.coinCount)


