extends Node
class_name LootTable

# Simple weighted loot
static var table := [
    {"name":"Spacerock Pebble","rarity":"common","weight":70.0,"steam_price":0.01},
    {"name":"Neon Shard","rarity":"uncommon","weight":22.0,"steam_price":0.05},
    {"name":"Cosmic Core","rarity":"rare","weight":7.0,"steam_price":0.50},
    {"name":"Banana Comet","rarity":"epic","weight":0.90,"steam_price":2.50},
    {"name":"Golden Banana","rarity":"legendary","weight":0.09,"steam_price":12.0},
    {"name":"Mythic Star Banana","rarity":"mythic","weight":0.01,"steam_price":50.0}
]

static func roll_drop(rng: RandomNumberGenerator) -> Dictionary:
    # 30% base chance for a drop
    if rng.randf() > 0.30:
        return {}
    var total: float = 0.0
    for i in table: total += i.weight
    var pick := rng.randf() * total
    var acc := 0.0
    for item in table:
        acc += item.weight
        if pick <= acc:
            return item
    return {}
