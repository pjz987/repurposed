class_name Enemy extends CharacterBody2D

const SPEED = 30

@export var Goal: Node = null

var BLOOD_SPLATTER_SCENE = preload("res://juice/blood_splatter.tscn")
var PICKUP_SCENE = preload("res://pickups/pickup.tscn")

@onready var health_bar: TextureProgressBar = $HealthBar

var Knockback: Vector2 = Vector2.ZERO
@export var max_health: int = 10
var health: int = max_health:
	set(value):
		health = value
		health_bar.value = float(health) / float(max_health)
		if health <= 0:
			die()

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
	if Globals.hero_alive and $NavigationAgent2D.target_position != Goal.global_position:
		$NavigationAgent2D.target_position = Goal.global_position
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bullet:
		Knockback = body.init_velocity.rotated(PI) * 0.3
		health -= 1
		trigger_blood_splatter(body)
		# body.queue_free()

func trigger_blood_splatter(body):
	var blood_splatter_scene = BLOOD_SPLATTER_SCENE.instantiate()
	blood_splatter_scene.global_position = global_position + body.velocity.normalized() * 20
	blood_splatter_scene.global_rotation = body.velocity.angle() + PI * 0.5
	get_tree().current_scene.add_child(blood_splatter_scene)

func drop_pickups():
	var pickup: Pickup = PICKUP_SCENE.instantiate() 
	pickup.pickup_type = Pickup.PICKUP_TYPE.OIL
	get_tree().current_scene.add_child(pickup)
	pickup.global_position = global_position

func die():
	drop_pickups()
	queue_free()
