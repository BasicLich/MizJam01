extends Node2D

onready var level_finished_ui = $UILayer/LevelFinishedUI

func finish_level():
	level_finished_ui.show_ui()
