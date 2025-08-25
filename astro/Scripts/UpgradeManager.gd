extends Node
extends Node

var upgrades = {
    "fire_rate": {"level": 0, "max": 5, "cost": 100, "effect": -0.02}, # reduces fire delay
    "bullet_speed": {"level": 0, "max": 5, "cost": 150, "effect": 50},
    "damage": {"level": 0, "max": 5, "cost": 200, "effect": 1}
}

var score_ref

func init(hud):
    score_ref = hud

func buy_upgrade(type):
    var upg = upgrades[type]
    if score_ref.score >= upg.cost and upg.level < upg.max:
        score_ref.score -= upg.cost
        upg.level += 1
        apply_upgrade(type)
        score_ref.update_score_label()

func apply_upgrade(type):
    match type:
        "fire_rate":
            var player = get_tree().get_first_node_in_group("player")
            player.fire_rate = max(0.05, player.fire_rate + upgrades[type].effect)
        "bullet_speed":
            Bullet.speed += upgrades[type].effect
        "damage":
            Bullet.damage += upgrades[type].effect
