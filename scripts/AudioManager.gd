extends Node
class_name AudioManager

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

func _process(delta: float) -> void:
    # Pitch follows game speed (subtle and smooth)
    var target := clamp(1.0 + (GameManager.game_speed - 1.0) * 0.4, 1.0, 2.5)
    music.pitch_scale = lerp(music.pitch_scale, target, 0.5 * delta)
