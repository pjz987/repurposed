extends Sprite2D

func _ready() -> void:
	if randf() > 0.5:
		texture = load("res://art/oil-1.png")
	else:
		texture = load("res://art/oil-2.png")
