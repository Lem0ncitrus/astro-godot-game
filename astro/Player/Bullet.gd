extends Node
extends Area2D

@export var speed := 600

func _process(delta):
    position.y -= speed * delta
    if position.y < -50:
        queue_free()

func _on_body_entered(body):
    if body.is_in_group("asteroid"):
        body.take_damage(1)
        queue_free()
