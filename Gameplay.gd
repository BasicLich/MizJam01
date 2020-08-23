extends Node2D

onready var buttons = $Levels

func _ready():
	buttons.get_child(0).grab_focus()
	for btn in buttons.get_children():
		btn.connect("focus_entered", self, "_on_button_focus_entered", [btn])
		btn.connect("focus_exited", self, "_on_button_focus_exited", [btn])
		if btn.name == "Level1":
			btn.get_child(0).show()
		else:
			btn.get_child(0).hide()
	
	# Check coins collected already
	for i in range(0, 3):
		var coins_collected = Globals.coins_in_levels[i]
		for j in range(0, 3):
			if coins_collected[j]:
				var slots = get_node("Levels/Level" + str(i+1) + "/CoinSlots/Slots/Slot" + str(j+1))
				if slots != null:
					slots.modulate = Color(1, 1, 1, 1)

func _on_button_focus_entered(btn):
	btn.get_node("Arrow").show()

func _on_button_focus_exited(btn):
	btn.get_node("Arrow").hide()

func _on_Level1_pressed():
	Globals.enter_level(0)

func _on_Level2_pressed():
	Globals.enter_level(1)

func _on_Back_pressed():
	get_tree().change_scene("res://Main.tscn")

