extends Node2D

onready var level_finished_ui = $UILayer/LevelFinishedUI
onready var theme = $ThemeSong
onready var coin_slots = $UILayer/CoinSlots/Slots

func _ready():
	theme.play()

func finish_level():
	theme.stop()
	level_finished_ui.show_ui()

func _on_coin_collected(i: int):
	var slot = coin_slots.get_node("Slot" + str(i+1))
	slot.modulate = Color(1, 1, 1, 1)
