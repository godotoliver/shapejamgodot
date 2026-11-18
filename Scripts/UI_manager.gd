extends Node

@onready var player: Node2D = get_tree().current_scene.get_node("Player")

@onready var level_label: Label = $LevelLabel
@onready var HP_label: Label = $HPLabel
@onready var score_label: Label = $ScoreLabel
@onready var gameover_UI: Control = $GameOverUI

func _process(_delta):
	if player.game_over:
		gameover_UI.visible = true
		return

	level_label.text = "Level: " + str(player.level)
	HP_label.text = "HP: " + str(player.health)
	score_label.text = "Score: " + str(player.score)
