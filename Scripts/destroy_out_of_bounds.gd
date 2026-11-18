extends Area2D


func _on_game_space_area_exited(area: Area2D) -> void:
	area.queue_free()
