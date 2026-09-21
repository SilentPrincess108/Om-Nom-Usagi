extends Node

var strawberry = preload("res://scenes/strawberry.tscn")
var pancakes = preload("res://scenes/pancakes.tscn")
var tomato = preload("res://scenes/tomato.tscn")
var lettuce = preload("res://scenes/lettuce.tscn")
var obstacle_types = [tomato, lettuce, strawberry, pancakes]
var obstacles: Array
var last_obs

@onready var usagi: CharacterBody2D = $Usagi
@onready var camera: Camera2D = $Camera2D
@onready var ground: StaticBody2D = $Ground
@onready var hud: CanvasLayer = $HUD
@onready var bgmusic: AudioStreamPlayer = $bgmusic


const USAGI_START_POS := Vector2i(165, 461)
const CAM_START_POS := Vector2i(576, 324)
const START_SPEED: float = 10.0
const MAX_SPEED: float = 25.0
const SCORE_MOD: int = 10
const SPEED_MOD: int = 5000

var speed: float
var screen_size: Vector2i
var ground_height: int = 115
var score: int
var game_running: bool = false

func _ready() -> void:
	screen_size = get_window().size
	hud.get_node("gameover").hide()
	hud.get_node("Play").hide()
	#ground_height = ground.get_node("Sprite2D").texture.get_height()
	new_game()
	bgmusic.stream.loop = true

func new_game():
	score = 0
	usagi.position = USAGI_START_POS
	usagi.velocity = Vector2i(0, 0)
	camera.position = CAM_START_POS
	ground.position = Vector2i(0, 0)

func generate_obstacles():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		var obs_name = obs_type.resource_path.get_file().get_basename()
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x: int = screen_size.x + score + 100
		var obs_y: int = randi_range(ground_height, screen_size.y/2 + 100)
		last_obs = obs
		obs.position = Vector2i(obs_x, obs_y)
		obs.body_entered.connect(hit_obs.bind(obs, obs_name))
		add_child(obs)
		obstacles.append(obs)
		

func hit_obs(body, obs, obs_name):
	if body.name == "Usagi":
		if obs_name == "strawberry" or obs_name == "pancakes":
			score += 100
			obs.queue_free()
		else:
			game_over()

func game_over():
	get_tree().paused = true
	game_running = false
	hud.get_node("gameover").show()
	hud.get_node("Play").show()

func update_score():
	hud.get_node("score").text = "Score: " + str(score / SCORE_MOD)

func _physics_process(delta: float) -> void:
	if game_running:
		speed = START_SPEED + score / SPEED_MOD
		score += speed
		update_score()
		generate_obstacles()
		
		#move player and camera
		usagi.position.x += speed
		camera.position.x += speed
		
		#upate ground position
		if camera.position.x - ground.position.x > screen_size.x * 1.5:
			ground.position.x += screen_size.x
	elif Input.is_action_just_pressed("jump"):
		game_running = true
		hud.get_node("start").hide()
		
