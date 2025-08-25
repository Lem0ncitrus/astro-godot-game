extends Node

@export var asteroid_scene: PackedScene
@export var area_rect: Rect2 = Rect2(0, -32, 1280, 0) # top edge span
@export var spawn_interval: float = 1.0

var timer: float = 0.0

func _process(delta: float) -> void:
    timer -= delta
    if timer <= 0.0:
        _spawn()
        var interval := spawn_interval / clamp(GameManager.game_speed, 1.0, 5.0)
        timer = max(0.15, interval)

func _spawn() -> void:
    if asteroid_scene == null:
        return
    var a := asteroid_scene.instantiate()
    get_tree().current_scene.add_child(a)
    var x := randf_range(area_rect.position.x, area_rect.position.x + area_rect.size.x)
    var y := area_rect.position.y
    a.global_position = Vector2(x, y)

    var s := randf_range(0.6, 1.4)
    a.scale = Vector2.ONE * s
    a.base_health = max(1, int(round(2 * s)))
    a.points = max(1, int(round(1 * s)))
