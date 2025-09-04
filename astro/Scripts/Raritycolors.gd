
extends Node
class_name RarityColors

static var colors := {
	"Common": Color(1, 1, 1),        # White
	"Rare": Color(0.2, 0.6, 1),      # Blue
	"Legendary": Color(1, 0.6, 0)    # Orange/Gold
}

static func get_color(rarity: String) -> Color:
	return colors.get(rarity, Color(1, 1, 1))
