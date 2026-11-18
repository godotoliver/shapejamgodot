extends Area2D

@export var speed: float = 250
@export var health: int = 50
@export var projectile_speed: float = 400
@export var fire_cooldown: float = 0.25

@onready var projectile_scene: PackedScene = preload("res://Scenes/Objects/projectile.tscn")
@onready var impact_scene: PackedScene = preload("res://Scenes/Objects/hazard_particles.tscn")

var level: int = 1
var score: int = 0
var game_over: bool = false
var fire_timer: float = 0.0

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(other: Area2D):
	if other.is_in_group("Powerup"):
		print("Level Up!")
		level += 1
		other.queue_free()
		
	if other.is_in_group("Hazard"):
		other.queue_free()
		
		var direction = other.direction
		var angle = Vector3(direction.x, direction.y, 0).normalized()
		
		var impact = impact_scene.instantiate()
		add_child(impact)
		impact.global_position = Vector2(other.global_position.x, other.global_position.y + 25)
		
		impact.process_material.direction = angle
		impact.emitting = true
		
		await get_tree().create_timer(0.2).timeout
		
		impact.emitting = false
		
		print("Player Hit!")
		health -= 5
		
		if health <= 0:
			die()

	
func die():
	game_over = true

func _process(delta):
	if game_over:
		if Input.is_action_pressed("reload"):
			get_tree().reload_current_scene()
		return
	
	# Movement code using two axes
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	translate(move_direction * speed * delta)
	position = position.clamp(Vector2.ZERO, get_viewport().get_visible_rect().size)
	
	fire_timer -= delta
	if Input.is_action_pressed("shoot") and fire_timer <= 0:
		fire_timer = fire_cooldown
		
		# --------------------
		# TODO 1 & 5
		# Player projectiles
		# --------------------
		var horizontal_offset: float = 25.0
		var vertical_offset: float = 20.0
		for i in range(level):
			var row = int((i + 1) / 2)
			var x_offset = horizontal_offset * row
			var y_offset = vertical_offset * row
			if i % 2 == 0:
				fire_projectile(Vector2(x_offset, y_offset))
			else:
				fire_projectile(Vector2(-x_offset, y_offset))
# --------------------
# TODO 5
# Fire projectile function
# --------------------
func fire_projectile(offset: Vector2):
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.direction = (get_viewport().get_mouse_position() - global_position).normalized()
	projectile.speed = projectile_speed
	projectile.global_position = global_position + offset
	get_tree().current_scene.add_child(projectile)
