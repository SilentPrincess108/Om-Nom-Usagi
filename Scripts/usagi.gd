extends CharacterBody2D

@onready var jump_sfx: AudioStreamPlayer2D = $jump_sfx


const GRAVITY = 3000
const JUMP_VELOCITY = -1500.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	get_input(delta)

func get_input(delta: float):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()
	
	move_and_slide()
	
