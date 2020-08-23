extends Node

const LEVELS = [
	"res://Levels/Level01.tscn",
	"res://Levels/Level02.tscn",
	"res://Levels/Level03.tscn",
]
var coins_in_levels = [
	[false, false, false],
	[false, false, false],
	[false, false, false]
]
var levels_unlocked = [
	true,
	false,
	false
]
var current_level_index = 0
var number_of_levels = 3

var coins_collected = 0

func _ready():
	OS.window_size = Vector2(800, 600)
	# Center the window after resizing
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func next_level():
	current_level_index += 1
	if current_level_index < LEVELS.size():
		levels_unlocked[current_level_index] = true
		get_tree().change_scene(LEVELS[current_level_index])
	else:
		# TODO: all levels finished
		get_tree().change_scene("res://Main.tscn")

func enter_level(index: int):
	current_level_index = index
	get_tree().change_scene(LEVELS[index])

func update_coins_collected_in_level(level_index: int, flags: Array):
	if flags.size() == 3:
		for i in range(3):
			coins_in_levels[level_index][i] = flags[i] or coins_in_levels[level_index][i]
