class_name Bullet extends CharacterBody2D

const SPEED: int = 500

var init_velocity: Vector2

func _physics_process(delta: float) -> void:
	var hit_something: bool = move_and_slide()
	if hit_something:
		if velocity.length() < init_velocity.length() * 0.5:
			queue_free()
		
func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	velocity = direction * SPEED
	init_velocity = velocity
	rotation = atan2(direction.y, direction.x)
