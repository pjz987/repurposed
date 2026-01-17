class_name Grenade extends CharacterBody2D

var SPEED: int = 100

const EXPLOSION: PackedScene = preload("res://explosion.tscn")

func _physics_process(delta: float) -> void:
	var hit_something: bool = move_and_slide()
	if hit_something:
		SPEED = 0
		$Timer.start
	else:
		SPEED *= 0.8
		if SPEED < 0.2:
			SPEED = 0
			$Timer.start
	
func explode(start_pos: Vector2, direction: Vector2) -> void:
	var inst: Explosion = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.start(start_pos, direction)

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	velocity = direction * SPEED
	rotation = atan2(direction.y, direction.x)
	$Timer.timeout.connect(explode)
