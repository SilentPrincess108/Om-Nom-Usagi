extends Node

@onready var usagi: CharacterBody2D = $Usagi
@onready var camera: Camera2D = $Camera2D
@onready var ground: StaticBody2D = $Ground
@onready var hud: CanvasLayer = $HUD


const USAGI_START_POS := Vector2i(165, 461)
const CAM_START_POS := Vector2i(576, 324)
const START_SPEED: float = 10.0
const MAX_SPEED: float = 25.0
const SCORE_MOD: int = 10
const SPEED_MOD: int = 5000

var speed: float
var screen_size: Vector2i
var score: int
var game_running: bool = false

func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game():
	score = 0
	usagi.position = USAGI_START_POS
	usagi.velocity = Vector2i(0, 0)
	camera.position = CAM_START_POS
	ground.position = Vector2i(0, 0)

func update_score():
	hud.get_node("score").text = "Score: " + str(score / SCORE_MOD)

func _physics_process(delta: float) -> void:
	if game_running:
		speed = START_SPEED + score / SPEED_MOD
		print(speed)
		score += speed
		update_score()
		
		#move player and camera
		usagi.position.x += speed
		camera.position.x += speed
		
		#upate ground position
		if camera.position.x - ground.position.x > screen_size.x * 1.5:
			ground.position.x += screen_size.x
	elif Input.is_action_just_pressed("jump"):
		game_running = true
		hud.get_node("start").hide()
		
