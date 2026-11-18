extends Area2D

var speed: float
var direction: Vector2

func _process(delta):
	translate(direction * speed * delta)
