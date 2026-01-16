class_name TankEnemy extends CharacterBody2D

var SPEED = 30


var OIL_SPLATTER_SCENE = preload("res://juice/oil_splatter.tscn")
var PICKUP_SCENE = preload("res://pickups/pickup.tscn")
var LIGHTNING_SCENE: PackedScene = preload("res://lightning.tscn")

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var lightning_spawn_point: Node2D = $Sprite2D/LightningSpawnPoint

var Knockback: Vector2 = Vector2.ZERO
var is_lightning_timeout: bool = false

@export var Goal: Node = null
@export var num_pickup_min: int = 3
@export var num_pickup_max: int = 10
@export var lightning_timeout: float = 2.5
@export var shooting_distance: float = 200.0
@export var max_health: int = 20
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
			#velocity -= Knockback
			Knockback *= 0.9
			if Knockback.length() < .2:
				Knockback = Vector2.ZERO
		move_and_slide()
		$Sprite2D.rotation = atan2(nav_point_direction.y, nav_point_direction.x)
	if Goal:
		ray_cast_2d.target_position = to_local(Goal.global_position)
		#print(ray_cast_2d.target_position.length())
		if ray_cast_2d.target_position.length() < shooting_distance and not ray_cast_2d.is_colliding():
			if not is_lightning_timeout:
				SPEED = 0
				await get_tree().create_timer(0.5).timeout
				fire_lightning()
				is_lightning_timeout = true
				await get_tree().create_timer(lightning_timeout).timeout
				is_lightning_timeout = false
				SPEED = 30

func fire_lightning():
	var lightning_scene: Lightning = LIGHTNING_SCENE.instantiate()
	lightning_scene.target_position = ray_cast_2d.target_position
	lightning_scene.global_position = lightning_spawn_point.global_position
	get_tree().current_scene.add_child(lightning_scene)
	MasterAudio.tank_shot.play()

func _on_timer_timeout() -> void:
	if Globals.hero_alive and $NavigationAgent2D.target_position != Goal.global_position:
		$NavigationAgent2D.target_position = Goal.global_position
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bullet:
		Knockback = body.init_velocity.rotated(PI) * 0.3
		health -= 1
		trigger_blood_splatter(body)
		MasterAudio.tank_hurt_pistol.play()
		# body.queue_free()

func trigger_blood_splatter(body):
	var oil_splatter_scene = OIL_SPLATTER_SCENE.instantiate()
	oil_splatter_scene.global_position = global_position + body.velocity.normalized() * 10
	oil_splatter_scene.global_rotation = body.velocity.angle() + PI * 0.5
	get_tree().current_scene.add_child(oil_splatter_scene)

func drop_pickups():
	var num_of_pickups: int = randi_range(num_pickup_min, num_pickup_max)
	for num in num_of_pickups:
		var pickup: Pickup = PICKUP_SCENE.instantiate()
		if randf() > 0.5:
			pickup.pickup_type = Pickup.PICKUP_TYPE.OIL
		else:
			pickup.pickup_type = Pickup.PICKUP_TYPE.METAL
		get_tree().current_scene.add_child(pickup)
		pickup.global_position = global_position + Vector2(randf_range(-20.0, 20.0), randf_range(-20.0, 20.0))

func die():
	drop_pickups()
	MasterAudio.tank_death.play()
	queue_free()
