extends Node
extends CharacterBody2D

@export var speed := 300
@export var bullet_scene: PackedScene
@export var fire_rate := 0.2

var fire_timer := 0.0

func _process(delta):
    var dir = Vector2.ZERO
    if Input.is_action_pressed("ui_up"):
        dir.y -= 1
    if Input.is_action_pressed("ui_down"):
        dir.y += 1
    if Input.is_action_pressed("ui_left"):
        dir.x -= 1
    if Input.is_action_pressed("ui_right"):
        dir.x += 1

    velocity = dir.normalized() * speed
    move_and_slide()

    fire_timer -= delta
    if Input.is_action_pressed("shoot") and fire_timer <= 0:
        shoot()
        fire_timer = fire_rate

func shoot():
    var bullet = bullet_scene.instantiate()
    bullet.global_position = global_position
    get_tree().current_scene.add_child(bullet)
s