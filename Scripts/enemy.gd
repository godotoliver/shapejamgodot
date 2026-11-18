extends Area2D

@export var speed: float = 50.0
@export var health: int = 10
@export var point_value: int = 500

@export var hazard_speed: float = 100.0
@export var attack_cooldown: float = 2.0

@onready var hazard_scene: PackedScene = preload("res://Scenes/Objects/hazard.tscn")
@onready var explosion_scene: PackedScene = preload("res://Scenes/Objects/explosion_particles.tscn")
@onready var player: Node2D = get_tree().current_scene.get_node("Player")
@onready var target: Vector2
@onready var attack_timer: float = 2.0

var rot_speed: float
var waypoints: Array[Node2D]


func _ready():
	# select a random waypoint as target
	target = waypoints[randi_range(0, len(waypoints) - 1)].global_position
	health = health + ((health / 2) * (player.level - 1))
	rot_speed = randf_range(4.0, 8.0) * [1, -1].pick_random()

func _on_area_entered(other: Area2D) -> void:
	if other.is_in_group("Projectile"):
		print("Enemy Hit!")
		other.queue_free()
		health -= 5
		if health <= 0:
			die()

func die():
	player.score += point_value + ((point_value / 2) * (player.level - 1))

	# spawn explosion particle system, set it's position,
	# turn it on, and set it to be destroyed when finished.
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.color = Color(1.0, 0.0, 0.0, 1.0)
	explosion.global_position = global_position
	queue_free()
	explosion.get_node("particle1").emitting = true
	explosion.get_node("particle2").emitting = true
	explosion.get_node("particle3").emitting = true
	explosion.connect("finished", Callable(explosion, "queue_free"))

func _process(delta):
	if player.game_over:
		return
	
	# if close to target waypoint select a new one
	var direction = target - global_position
	if direction.length() < 1:
		target = waypoints[randi_range(0, len(waypoints) - 1)].global_position
	
	# move the enemy towards the target
	translate(direction.normalized() * speed * delta)
	#rotate(rot_speed * delta)
	
	attack_timer -= delta
	if attack_timer <= 0:
		attack_timer = attack_cooldown
		
		# --------------------
		# TODO 3
		# Enemy hazard projectiles
		# --------------------
		var hazard: Area2D = hazard_scene.instantiate()
		hazard.global_position = Vector2(global_position.x, global_position.y - 40)
		hazard.direction = (player.global_position - global_position).normalized()
		hazard.speed = hazard_speed
		get_tree().current_scene.add_child(hazard)
