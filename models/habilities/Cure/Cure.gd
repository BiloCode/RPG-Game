extends Node2D

signal onParticleDestroy;

func _ready():
	$Particles.emitting = true;
	yield(get_tree().create_timer($Particles.lifetime + 0.5), "timeout");
	emit_signal("onParticleDestroy");
	queue_free();
