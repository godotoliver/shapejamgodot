extends Node2D

@export var powerup_speed: float = 200
@export var spawn_cooldown: float = 8

@onready var powerup_scene: PackedScene = preload("res://Scenes/Objects/powerup.tscn")
@onready var player: Node2D = get_tree().current_scene.get_node("Player")
@onready var spawn_timer: Timer = Timer.new()

func _ready():
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_cooldown
	spawn_timer.timeout.connect(_spawn_powerup)
	spawn_timer.start()
	
func _spawn_powerup():
	if player.game_over:
		return
	
	# --------------------
	# TODO 4
	# Power-up spawning
	# --------------------
	var random_x: float = randf_range(0, get_viewport_rect().size.x)
	var powerup: Area2D = powerup_scene.instantiate()
	powerup.direction = Vector2.DOWN
	powerup.speed = powerup_speed
	add_child(powerup)
