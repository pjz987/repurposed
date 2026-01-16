class_name Pickup extends Area2D

enum PICKUP_TYPE {METAL, OIL}
@export var pickup_type: PICKUP_TYPE
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if pickup_type == PICKUP_TYPE.METAL:
		sprite_2d.texture = load("res://art/metal-1.png")
	elif pickup_type == PICKUP_TYPE.OIL:
		sprite_2d.texture = load("res://art/oil.png")



func _on_body_entered(body: Node2D) -> void:
	if pickup_type == PICKUP_TYPE.METAL:
		Globals.metal += 1
	elif pickup_type == PICKUP_TYPE.OIL:
		Globals.oil += 1
	queue_free()
