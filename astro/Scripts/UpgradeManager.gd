extends Node
class_name UpgradeManager

var upgrades = {
	"fire_rate": {"level": 0, "max": 5, "cost": 100, "effect": -0.02}, # reduces fire delay
	"bullet_speed": {"level": 0, "max": 5, "cost": 150, "effect": 50},
	"damage": {"level": 0, "max": 5, "cost": 200, "effect": 1}
}

var score_ref

func init(hud):
	score_ref = hud

func buy_upgrade(type: String):
	if not upgrades.has(type):
		print("Upgrade type not found:", type)
		return

	var upg = upgrades[type]
	if score_ref.score >= upg.cost and upg.level < upg.max:
		score_ref.score -= upg.cost
		upg.level += 1
		apply_upgrade(type)
		score_ref.update_score_label()
	else:
		print("Not enough score or upgrade maxed out.")

func apply_upgrade(type: String):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("UpgradeManager: Player not found!")
		return

	match type:
		"fire_rate":
			if player.has_variable("fire_rate"):
				player.fire_rate = max(0.05, player.fire_rate + upgrades[type].effect)
			else:
				print("Player missing 'fire_rate' property")
	
