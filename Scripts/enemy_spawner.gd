extends Node2D

@export var spawn_cooldown: float = 5

@onready var giant_enemy_scene: PackedScene = preload("res://Scenes/Objects/giant_enemy.tscn")
@onready var enemy_scene: PackedScene = preload("res://Scenes/Objects/enemy.tscn")
@onready var player: Node2D = get_tree().current_scene.get_node("Player")
@onready var waypoints: Array[Node2D] = [
	$"Waypoints/Waypoint 1",
	$"Waypoints/Waypoint 2",
	$"Waypoints/Waypoint 3",
	$"Waypoints/Waypoint 4",
	$"Waypoints/Waypoint 5",
]
@onready var spawn_timer: Timer = Timer.new()

func _ready():
	add_child(spawn_timer) 
	spawn_timer.wait_time = spawn_cooldown
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.start()

func _spawn_normal_enemy():
	var enemy: Area2D = enemy_scene.instantiate()
	enemy.waypoints = waypoints
	add_child(enemy)
	enemy.global_position = global_position
	
func _spawn_giant_enemy():
	var bigenemy: Area2D = giant_enemy_scene.instantiate()
	bigenemy.waypoints = waypoints
	add_child(bigenemy)
	bigenemy.global_position = global_position

func _spawn_enemy():
	if player.game_over:
		return
	
	# --------------------
	# TODO 2
	# Enemy spawning
	# --------------------
	if randf() >= 0.4:
		_spawn_normal_enemy()
	else:
		_spawn_giant_enemy()
