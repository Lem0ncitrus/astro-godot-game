extends Area2D

@export var speed: float = 900.0
@export var lifetime: float = 2.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
    $CollisionShape2D.disabled = false
    await get_tree().create_timer(lifetime).timeout
    queue_free()

func _physics_process(delta: float) -> void:
    global_position += direction * speed * delta

func _on_Bullet_body_entered(body: Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage(1)
    queue_free()
