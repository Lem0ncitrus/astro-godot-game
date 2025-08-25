extends Node
extends RigidBody2D

@export var health := 3
@export var explosion_scene: PackedScene
@export var item_drop_scene: PackedScene
@export var drop_chance := 0.3

func take_damage(amount):
    health -= amount
    if health <= 0:
        explode()

func explode():
    var explosion = explosion_scene.instantiate()
    explosion.global_position = global_position
    get_tree().current_scene.add_child(explosion)

    if randf() <= drop_chance:
        drop_item()

    queue_free()

func drop_item():
    var item = item_drop_scene.instantiate()
    item.global_position = global_position
    get_tree().current_scene.add_child(item)
