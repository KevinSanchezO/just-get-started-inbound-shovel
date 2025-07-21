extends Node

const weapon_dict := {
	1 : "res://scenes/game_objects/weapons/range_weapons/pistol/pistol.tscn", # pistol
	2 : "res://scenes/game_objects/weapons/range_weapons/shotgun/shotgun.tscn", # shotgun
	3 : "res://scenes/game_objects/weapons/range_weapons/uzi/uzi.tscn", # uzi
	4 : "res://scenes/game_objects/weapons/range_weapons/crossbow/crossbow.tscn", # crossbow
	5 : "res://scenes/game_objects/weapons/melee_weapons/shovel/shovel.tscn", # shovel
	6 : "res://scenes/game_objects/weapons/melee_weapons/hammer/hammer.tscn", # hammer
	7 : "res://scenes/game_objects/weapons/melee_weapons/spear/spear.tscn", # spear
	#8 : "res://scenes/game_objects/weapons/range_weapons/dice/dice.tscn", # dice
}

func select_random_weapons() -> Array:
	const ranged_ids := [1, 2, 3, 4]
	const melee_ids := [5, 6, 7]
	
	var all_ids = weapon_dict.keys()
	var first_id = all_ids[randi() % all_ids.size()]
	var second_id := -1
	
	if first_id in melee_ids:
		# First is melee, second must be ranged
		second_id = ranged_ids[randi() % ranged_ids.size()]
	else:
		# First is ranged, second must be different
		var available_ids = all_ids.duplicate()
		available_ids.erase(first_id)
		second_id = available_ids[randi() % available_ids.size()]
	return [weapon_dict[first_id], weapon_dict[second_id]]
	
