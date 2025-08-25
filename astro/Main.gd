extends Node
extends Node2D

@export var asteroid_scene: PackedScene
@export var spawn_interval := 1.0
var spawn_timer := 0.0

func _process(delta):
    spawn_timer -= delta
    if spawn_timer <= 0:
        spawn_asteroid()
        spawn_timer = spawn_interval

func spawn_asteroid():
    var asteroid = asteroid_scene.instantiate()
    asteroid.global_position = Vector2(randf() * 800, -50)
    get_tree().current_scene.add_child(asteroid)
