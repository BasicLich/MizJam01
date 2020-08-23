extends Node2D

onready var level_finished_ui = $UILayer/LevelFinishedUI
onready var theme = $ThemeSong

func _ready():
	theme.play()

func finish_level():
	theme.stop()
	level_finished_ui.show_ui()
