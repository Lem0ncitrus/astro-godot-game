extends Node
class_name GameManager

signal score_changed(new_score: int)
signal drop_obtained(item: Dictionary)

var score: int = 0
var game_speed: float = 1.0
var last_drop: Dictionary = {}
var rng := RandomNumberGenerator.new()

func _ready() -> void:
    rng.randomize()
    _ensure_input_map()

func _process(delta: float) -> void:
    # Slow, passive ramp over time
    game_speed = clamp(game_speed + delta * 0.01, 1.0, 5.0)

func add_score(points: int) -> void:
    score += points
    emit_signal("score_changed", score)

func on_asteroid_destroyed(points: int = 1) -> void:
    add_score(points)
    game_speed = clamp(game_speed + 0.02, 1.0, 5.0)
    var item := LootTable.roll_drop(rng)
    if item.size() > 0:
        last_drop = item
        emit_signal("drop_obtained", item)

func _ensure_input_map() -> void:
    var actions := {
        "move_left": [KEY_A, KEY_LEFT],
        "move_right": [KEY_D, KEY_RIGHT],
        "move_up": [KEY_W, KEY_UP],
        "move_down": [KEY_S, KEY_DOWN],
        "shoot": [KEY_SPACE]
    }
    for action in actions.keys():
        if not InputMap.has_action(action):
            InputMap.add_action(action)
        for key in actions[action]:
            var ev := InputEventKey.new()
            ev.physical_keycode = key
            InputMap.action_add_event(action, ev)
