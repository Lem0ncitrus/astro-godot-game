extends Area2D

@export var item_data: ItemData

func _ready():
	$Sprite2D.texture = item_data.icon
	$Sprite2D.modulate = RarityColors.get_color(item_data.rarity)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		var hud = get_tree().get_first_node_in_group("hud")
		hud.add_item_to_inventory(item_data)
		queue_free()
