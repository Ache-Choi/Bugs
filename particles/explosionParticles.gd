extends Spatial



func _ready():
	$CPUParticles.emitting = true
	$Timer.start()


func _on_Timer_timeout():
	self.queue_free()
