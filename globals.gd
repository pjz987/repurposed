extends Node

var hero: Player

var hero_alive: bool = true

var metal: int = 100:
	set(in_num):
		metal = in_num
		refresh_resource_icons.emit()

var oil: int = 50:
	set(in_num):
		oil = in_num
		refresh_resource_icons.emit()

signal refresh_char_sprite
signal refresh_resource_icons

enum Equipped {
	FISTS,
	BASIC_GUN,
	SHOTGUN,
}

var active_gun := Equipped.BASIC_GUN

var item_costs: Dictionary = {
	# [metal cost, oil cost]
	Equipped.FISTS: [0, 0],
	Equipped.BASIC_GUN: [10, 5],
}

var display_names: Dictionary = {
	Equipped.FISTS: "Fists",
	Equipped.BASIC_GUN: "Basic Gun",
}

func check_afford_bullet() -> bool:
	return (
		metal >= item_costs[active_gun][0] and 
		oil >= item_costs[active_gun][1]
		)
