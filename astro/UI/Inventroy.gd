extends Control

var items: Array = []

func add_item(item: ItemData):
	items.append(item)
	refresh_inventory()

func refresh_inventory():
	var grid = $GridContainer
	grid.clear() # Custom helper to remove children
	for item in items:
		var slot = Label.new()
		slot.text = item.name
		slot.modulate = RarityColors.get_color(item.rarity)
		grid.add_child(slot)

func clear():
	for child in $GridContainer.get_children():
		child.queue_free()
