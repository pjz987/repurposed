extends Node2D



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SPACE"):
		visible = not visible
		if visible:
			global_rotation = 0
			get_tree().paused = true
		else:
			get_tree().paused = false
