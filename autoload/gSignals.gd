extends Node

signal instSound
func inst_sounds(soundName):
	emit_signal("instSound", soundName)

signal instCountText
func inst_count_text_mesh(pos):
	emit_signal('instCountText', pos)

signal instCoinGem
func inst_coin_mesh(pos):
	emit_signal('instCoinGem', pos)

signal updateCoins
func update_coin_count():
	emit_signal('updateCoins') 

signal camShake
func cam_shake():
	emit_signal('camShake')

signal instHuntingChar
func inst_hunt_chracter_after():
	emit_signal('instHuntingChar')

signal changeScene
func g_change_scene():
	emit_signal('changeScene')

signal instShipBulletParticles
func inst_ship_bullet_particles(pos):
	emit_signal('instShipBulletParticles', pos)

signal playerShipShoot
func player_ship_shoot():
	emit_signal('playerShipShoot')

signal updateLabCounts
func update_lab_counts():
	emit_signal('updateLabCounts')

signal instGroundRocks
func inst_ground_rocks(pos):
	emit_signal('instGroundRocks', pos)

signal instBallExplosionParticles
func inst_ball_explosion_particles(pos):
	emit_signal('instBallExplosionParticles', pos)

signal instBugBall
func inst_bug_balls(pos, count, type, to):
	emit_signal('instBugBall', pos, count, type,to)

signal groundAttackGorillaFX
func inst_gorilla_ground_fx(type, pos, rot):
	emit_signal("groundAttackGorillaFX",type, pos, rot)

signal playerAttack
func player_attack(rot):
	emit_signal("playerAttack", rot)
