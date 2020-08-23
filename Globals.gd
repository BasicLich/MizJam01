extends Node

const LEVELS = [
	"res://Levels/Level01.tscn",
	"res://Levels/Level02.tscn",
	"res://Levels/Level03.tscn",
]
var current_level_index = 0

var coins_collected = 0

func next_level():
	current_level_index += 1
	if current_level_index < LEVELS.size():
		get_tree().change_scene(LEVELS[current_level_index])
	else:
		# TODO: all levels finished
		get_tree().change_scene("res://Main.tscn")
