extends RigidBody2D

@export var base_health: int = 3
@export var points: int = 1

var health: int
var exploded := false

@onready var particles: CPUParticles2D = $Explosion

func _ready() -> void:
    health = int(round(base_health * randf_range(0.8, 1.4)))
    # Gentle downward drift; spawner sets position
    linear_velocity = Vector2(randf_range(-60, 60), randf_range(120, 220)) * GameManager.game_speed

func take_damage(dmg: int) -> void:
    health -= dmg
    if health <= 0 and not exploded:
        _explode()

func _explode() -> void:
    exploded = true
    # Random fireworks color
    particles.modulate = Color.from_hsv(randf(), 1.0, 1.0)
    particles.emitting = true

    GameManager.on_asteroid_destroyed(points)

    $Sprite2D.visible = false
    $CollisionShape2D.disabled = true

    await get_tree().create_timer(0.4).timeout
    queue_free()
