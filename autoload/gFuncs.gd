extends Node


func solidBlack_fade(cont, animName):
	var f = load('res://scenes/ui/fade%s.tscn'%animName).instance()
	cont.add_child(f)

func convert_to_degrees(joyStickVec):
	var v1 = Vector2(0,-1) * 1000
	var v2 = joyStickVec * 1000
	var dotP = ((v1.x * v2.x)+(v1.y * v2.y))
	var v1mag = sqrt((v1.x*v1.x)+(v1.y*v1.y)) 
	var v2mag = sqrt((v2.x*v2.x)+(v2.y*v2.y))
	if v2mag > 0:
		if joyStickVec.x > 0:
			var result = -rad2deg(acos((dotP/(v1mag*v2mag))))
			return result
		else:
			var result = rad2deg(acos((dotP/(v1mag*v2mag))))
			return result

func shuffle_position_arr(arrSize):
	var passArr = []
	var tempShuffledArr = []
	var num0
	randomize()
	for i in arrSize:
		passArr.append(i)
	while passArr.size() > 0:
		num0 = floor(rand_range(0, passArr.size()))
		tempShuffledArr.append(passArr[num0])
		passArr.remove(num0)
	return tempShuffledArr
