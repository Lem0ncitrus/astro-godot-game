extends Resource
class_name ItemData

@export var name: String
@export_enum("Common", "Rare", "Legendary") var rarity: String = "Common"
@export var icon: Texture2D
@export var description: String
