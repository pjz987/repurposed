class_name Player extends CharacterBody2D

const SPEED: int = 90
const BULLET: PackedScene = preload("res://bullet.tscn")

@onready var hurtbox: Area2D = $Hurtbox

var invincible: bool = false

@export var invincibility_timeout: float = 1.0
@export var max_health: int = 20
var health: int = max_health:
	set(value):
		health = value
		if health <= 0:
			die()

func _ready() -> void:
	Globals.refresh_char_sprite.connect(refresh_char_sprite)

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed == true):
		if Globals.active_gun == Globals.Equipped.BASIC_GUN:
			var inst: Bullet = BULLET.instantiate()
			var start_pos: Vector2 = global_position 
			var direction: Vector2 = start_pos.direction_to(get_global_mouse_position())
			start_pos += 10 * direction
			get_tree().current_scene.add_child(inst)
			inst.start(start_pos, direction)
			MasterAudio.gunshot_basic.play()
			Globals.oil -= 1
			Globals.metal -= 2
			
			print("oil: ",  Globals.oil, "\nmetal: ",  Globals.metal)

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
			health -= 1
			print("took damage")
			invincible = true
			await get_tree().create_timer(invincibility_timeout).timeout
			invincible = false


func refresh_char_sprite() -> void:
	if Globals.active_gun == Globals.Equipped.FISTS:
		$Sprite2D.texture = load("res://art/hero-unarmed.png")
	elif Globals.active_gun == Globals.Equipped.BASIC_GUN:
		$Sprite2D.texture = load("res://art/hero.png")
