class_name Bullet extends CharacterBody2D

const SPEED: int = 500

func _physics_process(delta: float) -> void:
	var hit_something: bool = move_and_slide()
	if hit_something:
		queue_free()
		
func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	velocity = direction * SPEED
	rotation = PI + atan2(direction.y, direction.x)
