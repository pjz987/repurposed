class_name Enemy extends CharacterBody2D

const SPEED = 30

@export var Goal: Node = null

var Knockback: Vector2 = Vector2.ZERO
var health: int = 20

func _ready() -> void:
	$NavigationAgent2D.target_position = Goal.global_position
	$Timer.start()

func _physics_process(delta: float) -> void:
	var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	if !$NavigationAgent2D.is_target_reached():
		velocity = nav_point_direction * SPEED
		if Knockback != Vector2.ZERO:
			velocity -= Knockback
			Knockback *= 0.9
			if Knockback.length() < .2:
				Knockback = Vector2.ZERO
		move_and_slide()
		$Sprite2D.rotation = atan2(nav_point_direction.y, nav_point_direction.x)



func _on_timer_timeout() -> void:
	if $NavigationAgent2D.target_position != Goal.global_position:
		$NavigationAgent2D.target_position = Goal.global_position
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bullet:
		Knockback = body.init_velocity.rotated(PI) * 0.3
		health -= 1
		# body.queue_free()
		if health <= 0:
			queue_free()
