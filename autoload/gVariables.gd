extends Node

onready var nextScenePath = "res://scenes/levels/levelScene/levelEnviroment.tscn"

onready var gorillaHP = 80
onready var gorillaMaxHP = 100
onready var gorillaLevel = 0
onready var gorillaCount = 5
onready var gorillaGlovesOn = true

onready var snakeHP = 80
onready var snakeMaxHP = 100
onready var snakeLevel = 1
onready var snakeCount = 2
onready var snakeGlovesOn = false

onready var coinCount = 19
onready var attackDamage = 20
# playerChosenNum  refers to playerArrNames   
onready var playerChosenNum = 0
onready var playerArrNames = ['gorillaPlayer', 'snakePlayer']
onready var highScore = 0
#onready var playerCoins = 0
onready var playerPos = Vector3(0,0,0)
onready var gameOn = true

onready var currentLevel = 0
onready var levelCompleted = 0

onready var bugsHP = {"ballThrower": 100, 
					  "ballThrower2": 150, 
					  "cannonBug": 350
					}
onready var musicOnOff = true
onready var soundOnOff = true

onready var highScoreNameArr = ['-----','-----','-----','-----','-----']
onready var highScoreArr = [0,0,0,0,0]
