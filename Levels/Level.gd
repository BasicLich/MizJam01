extends Node2D

onready var level_finished_ui = $UILayer/LevelFinishedUI
onready var theme = $ThemeSong
onready var coin_slots = $UILayer/CoinSlots/Slots

onready var coins_collected = [false, false, false]

func _ready():
	randomize()
	theme.play()
	
	# Update coins UI if coins were already collected
	var global_coins = Globals.coins_in_levels[Globals.current_level_index]
	for i in range(3):
		if global_coins[i]:
			_on_coin_collected(i)

func stop_music():
	theme.stop()

func finish_level():
	theme.stop()
	level_finished_ui.show_ui()
	check_coins_collected()

func check_coins_collected():
	Globals.update_coins_collected_in_level(Globals.current_level_index, coins_collected)

func _on_coin_collected(i: int):
	var slot = coin_slots.get_node("Slot" + str(i+1))
	slot.modulate = Color(1, 1, 1, 1)
	coins_collected[i] = true
