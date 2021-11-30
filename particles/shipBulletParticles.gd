extends Spatial


func _ready():
	$CPUParticles.emitting = true
	$Timer.start()
	$AnimationPlayer.play("ringFX")

func _on_Timer_timeout():
	self.queue_free()
