class_name Lightning extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var speed: float = 150.0

var target_position: Vector2
var direction: Vector2

@export var lightning_animation_speed: float = 0.5

func _ready() -> void:
	direction = global_position.direction_to(target_position)
	velocity = direction * speed
	rotation = atan2(direction.y, direction.x)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	sprite_2d.flip_h = not sprite_2d.flip_h
