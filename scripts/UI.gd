extends CanvasLayer

@onready var score_label: Label = $Margin/Row/Score
@onready var speed_label: Label = $Margin/Row/Speed
@onready var drop_label: Label = $Margin/Drop

func _ready() -> void:
    GameManager.connect("score_changed", Callable(self, "_on_score_changed"))
    GameManager.connect("drop_obtained", Callable(self, "_on_drop"))
    _on_score_changed(GameManager.score)

func _process(delta: float) -> void:
    speed_label.text = "Speed: %.2f" % GameManager.game_speed

func _on_score_changed(value: int) -> void:
    score_label.text = "Score: %d" % value

func _on_drop(item: Dictionary) -> void:
    if item.size() == 0:
        return
    drop_label.text = "DROP: %s (%s) — est. $%.2f" % [item.name, item.rarity, item.steam_price]
    drop_label.modulate = Color(1, 1, 0.3, 1)
    await get_tree().create_timer(2.5).timeout
    drop_label.text = ""
    drop_label.modulate = Color(1,1,1,1)
