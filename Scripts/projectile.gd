extends Area2D

var speed: float
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	visible = true
	look_at(global_position + direction)
	position += direction * speed * delta
