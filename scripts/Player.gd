extends CharacterBody2D

@export var move_speed: float = 420.0
@export var bullet_scene: PackedScene
@export var fire_cooldown: float = 0.15

var can_fire := true

func _ready() -> void:
    # Auto-assign bullet scene if not set
    if bullet_scene == null:
        bullet_scene = load("res://scenes/Bullet.tscn")

func _physics_process(delta: float) -> void:
    var dir := Vector2.ZERO
    if Input.is_action_pressed("move_left"): dir.x -= 1.0
    if Input.is_action_pressed("move_right"): dir.x += 1.0
    if Input.is_action_pressed("move_up"): dir.y -= 1.0
    if Input.is_action_pressed("move_down"): dir.y += 1.0

    velocity = dir.normalized() * move_speed
    move_and_slide()

    look_at(get_global_mouse_position())

    if Input.is_action_pressed("shoot") and can_fire:
        _shoot()

func _shoot() -> void:
    if bullet_scene == null:
        return
    var b := bullet_scene.instantiate()
    get_tree().current_scene.add_child(b)
    b.global_position = global_position + (transform.x * 32.0)
    b.direction = (get_global_mouse_position() - global_position).normalized()
    can_fire = false
    await get_tree().create_timer(fire_cooldown / max(0.001, GameManager.game_speed)).timeout
    can_fire = true
