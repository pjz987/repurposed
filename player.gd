class_name Player extends CharacterBody2D

const BASE_SPEED: int = 90
const STUN_SPEED: int = 60
var SPEED: int = BASE_SPEED
const BULLET: PackedScene = preload("res://bullet.tscn")

@onready var hurtbox: Area2D = $Hurtbox

var invincible: bool = false

@export var invincibility_timeout: float = 1.0
@export var max_health: int = 20
var health: int = max_health:
	set(value):
		health = value
		Globals.refresh_resource_icons.emit()
		if health <= 0:
			die()

func _ready() -> void:
	Globals.refresh_char_sprite.connect(refresh_char_sprite)
	Globals.hero = self

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed == true):
		if Globals.check_afford_bullet():
			Globals.pay_for_bullet()
			var start_pos: Vector2 = global_position 
			var direction: Vector2 = start_pos.direction_to(get_global_mouse_position())
			start_pos += 10 * direction
			var inst: Node2D
			match(Globals.active_gun):
				Globals.Equipped.FISTS:
					inst = BULLET.instantiate()
				Globals.Equipped.BASIC_GUN:
					MasterAudio.gunshot_basic.play()
					inst = BULLET.instantiate()
				Globals.Equipped.SHOTGUN:
					inst = BULLET.instantiate()
				Globals.Equipped.GRENADE_LAUNCHER:
					inst = BULLET.instantiate()
				Globals.Equipped.FLAMETHROWER:
					inst = BULLET.instantiate()
			get_tree().current_scene.add_child(inst)
			inst.start(start_pos, direction)
			
		if Globals.active_gun == Globals.Equipped.FISTS:
			pass

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

	check_for_attack()

#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#print("zombie hit player")
	#if not invincible:
		#health -= 1
	#await get_tree().create_timer(1.0).timeout
	#invincible = true
	#print(hurtbox.get_overlapping_areas())
	

func die():
	print("player died")
	Globals.hero_alive = false
	queue_free()
	
func check_for_attack():
	if not invincible:
		if hurtbox.get_overlapping_areas():
			var overlapping_nodes = hurtbox.get_overlapping_areas()

				
			health -= 1
			print("took damage")
			MasterAudio.player_hurt.play()
			invincible = true
			for item in overlapping_nodes:
				if item.get_parent() is Lightning:
					handle_stun()
			await get_tree().create_timer(invincibility_timeout).timeout
			invincible = false

func handle_stun() -> void:
	SPEED = STUN_SPEED
	await get_tree().create_timer(0.5).timeout
	SPEED = BASE_SPEED

func refresh_char_sprite() -> void:
	if Globals.active_gun == Globals.Equipped.FISTS:
		$Sprite2D.texture = load("res://art/hero-unarmed.png")
	elif Globals.active_gun == Globals.Equipped.BASIC_GUN:
		$Sprite2D.texture = load("res://art/hero.png")
