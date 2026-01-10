extends CharacterBody2D

const SPEED: int = 90
const BULLET: PackedScene = preload("res://bullet.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var inst: Bullet = BULLET.instantiate()
		var start_pos: Vector2 = global_position 
		var direction: Vector2 = start_pos.direction_to(get_global_mouse_position())
		get_owner().add_child(inst)
		inst.start(start_pos, direction)

func _physics_process(delta: float) -> void:
	
	# point character at mouse
	var direction: Vector2 = global_position.direction_to(get_global_mouse_position())
	rotation = PI + atan2(direction.y, direction.x)
	
	# track changes in x/y movement
	var x_move: int = 0
	var y_move: int = 0	
	if Input.is_action_pressed("ui_left"):
		x_move -= 1
	if Input.is_action_pressed("ui_right"):
		x_move += 1
	if Input.is_action_pressed("ui_up"):
		y_move -= 1
	if Input.is_action_pressed("ui_down"):
		y_move += 1
		
	if x_move: # if one x direction pressed
		velocity.x = x_move * SPEED
	else: # x momentum
		if abs(velocity.x) > 0.2: # slow
			velocity.x *= 0.9
		else: # stop
			velocity.x = 0

	if y_move: # if one y direction pressed
		velocity.y = y_move * SPEED
	else: # y momentum
		if abs(velocity.y) > 0.2: # slow
			velocity.y *= 0.9
		else: # stop
			velocity.y = 0

	move_and_slide()
