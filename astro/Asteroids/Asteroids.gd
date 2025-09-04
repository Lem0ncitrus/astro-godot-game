
extends RigidBody2D

@export var health := 3
@export var explosion_scene: PackedScene
@export var item_drop_scene: PackedScene
@export var drop_chance := 0.3

var asteroid_scene = preload("res://Asteroids/Asteroids.tscn")  # or load()



func _ready():
	var asteroid_instance = asteroid_scene.instantiate()
	add_child(asteroid_instance)


func take_damage(amount):
	health -= amount
	if health <= 0:
		explode()

func explode():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)

	if randf() <= drop_chance:
		drop_item()

	queue_free()

func drop_item():
	var item = item_drop_scene.instantiate()
	item.global_position = global_position

	# Assign random rarity
	var rarity_roll = randf()
	var rarity = "Common"
	if rarity_roll > 0.95:
		rarity = "Legendary"
	elif rarity_roll > 0.7:
		rarity = "Rare"

	var new_item_data = ItemData.new()
	new_item_data.name = rarity + " Crystal"
	new_item_data.rarity = rarity
	# Assign icon textures per rarity if you have them
	item.item_data = new_item_data


	get_tree().current_scene.add_child(item)
