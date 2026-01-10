extends CharacterBody2D

const SPEED: int = 90
const BULLET: PackedScene = preload("res://bullet.tscn")

@onready var _sprite: Sprite2D = $Sprite2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var inst: Bullet = BULLET.instantiate()
		var start_pos: Vector2 = global_position 
		var direction: Vector2 = start_pos.direction_to(get_global_mouse_position())
		get_owner().add_child(inst)
		inst.start(start_pos, direction)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(get_global_mouse_position())
	rotation = PI + atan2(direction.y, direction.x)
	var zero_speed: bool = true
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		zero_speed = false
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		zero_speed = false
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
		zero_speed = false
	if Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
		zero_speed = false
	move_and_slide()
	if zero_speed:
		if min(abs(velocity.x), abs(velocity.y)) > .2:
			velocity *= Vector2(0.9, 0.9)
		else:
			velocity = Vector2.ZERO

	
