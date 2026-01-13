extends Node

var hero_alive: bool = true
var metal: int = 100
var oil: int = 50

enum Equipped {
	FISTS,
	BEGINNING_GUN,
}

var active_gun := Equipped.BEGINNING_GUN

var item_costs: Dictionary = {
	# [metal cost, oil cost]
	Equipped.FISTS: [0, 0],
	Equipped.BEGINNING_GUN: [10, 5],
}

var display_names: Dictionary = {
	Equipped.FISTS: "Fists",
	Equipped.BEGINNING_GUN: "Beginning Gun",
}
