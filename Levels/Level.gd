extends Node2D

onready var level_finished_ui = $UILayer/LevelFinishedUI
onready var theme = $ThemeSong
onready var coin_slots = $UILayer/CoinSlots/Slots
onready var pause_menu = $UILayer/PauseMenu
onready var transition_animation_player = $UILayer/AnimationPlayer

onready var player_died = false
onready var coins_collected = [false, false, false]

func _ready():
	randomize()
	
	# Update coins UI if coins were already collected
	var global_coins = Globals.coins_in_levels[Globals.current_level_index]
	for i in range(3):
		if global_coins[i]:
			_on_coin_collected(i)
	
	transition_animation_player.connect("animation_finished", self, "_transition_anim_finished")
	transition_animation_player.play("start_transition")

func stop_music():
	theme.stop()

func finish_level():
	theme.stop()
	level_finished_ui.show_ui()
	check_coins_collected()
	pause_menu.can_pause = false

func play_death_transition():
	player_died = true
	transition_animation_player.play("end_transition")

func play_next_transition():
	transition_animation_player.play("end_transition")

func check_coins_collected():
	Globals.update_coins_collected_in_level(Globals.current_level_index, coins_collected)

func _on_coin_collected(i: int):
	var slot = coin_slots.get_node("Slot" + str(i+1))
	slot.modulate = Color(1, 1, 1, 1)
	coins_collected[i] = true

func _transition_anim_finished(anim):
	if anim == "start_transition":
		theme.play()
	elif anim == "end_transition":
		if player_died:
			get_tree().reload_current_scene()
		else:
			Globals.next_level()
