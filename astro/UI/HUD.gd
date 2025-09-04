
extends CanvasLayer
class_name HUD
@onready var inventory_ui = $Inventory

var score := 0

func update_score_label():
	$ScoreLabel.text = "Score: %d" % score


func add_score(points):
	score += points
	$ScoreLabel.text = "Score: %d" % score

func add_item_to_inventory(item: ItemData):
	inventory_ui.add_item(item)

func _ready():
	add_to_group("hud")
