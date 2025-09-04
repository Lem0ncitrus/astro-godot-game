
extends Area2D

@export var speed := 400
@export var damage := 1

func _process(delta):
	position.y -= speed * delta
	if position.y < -50:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("asteroid"):
		body.take_damage(damage)
		queue_free()  # <-- Add parentheses here
