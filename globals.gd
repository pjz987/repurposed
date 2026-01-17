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
	GRENADE_LAUNCHER,
	FLAMETHROWER,
}

var active_gun := Equipped.BASIC_GUN

var item_costs: Dictionary = {
	# [metal cost, oil cost]
	Equipped.FISTS: [0, 0],
	Equipped.BASIC_GUN: [10, 5],
	Equipped.SHOTGUN: [100, 30],
	Equipped.GRENADE_LAUNCHER: [150, 30],
	Equipped.FLAMETHROWER: [200, 50],
}

var display_names: Dictionary = {
	Equipped.FISTS: "Fists",
	Equipped.BASIC_GUN: "Basic Gun",
	Equipped.SHOTGUN: "Shotgun",
	Equipped.GRENADE_LAUNCHER: "Grenade Launcher",
	Equipped.FLAMETHROWER: "Flamethrower",
}

var bullet_costs: Dictionary = {
	Equipped.FISTS: [0, 0],
	Equipped.BASIC_GUN: [2, 0],
	Equipped.SHOTGUN: [5, 2],
	Equipped.GRENADE_LAUNCHER: [20, 20],
	Equipped.FLAMETHROWER: [0, 20],
}

func check_afford_bullet() -> bool:
	return (
		metal >= bullet_costs[active_gun][0] and 
		oil >= bullet_costs[active_gun][1]
		)

func pay_for_bullet() -> void:
	metal -= bullet_costs[active_gun][0]
	oil -= bullet_costs[active_gun][1]
