
extends Node2D

@export var lifetime := 1.0

func _ready():
	var particles = $CPUParticles2D
	particles.emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
