extends CharacterBody2D

const GRAVITY = 3000
const JUMP_VELOCITY = -900.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	get_input(delta)

func get_input(delta: float):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()
	
