extends Node2D

onready var buttons = $Buttons

func _ready():
	buttons.get_child(0).grab_focus()
	for btn in buttons.get_children():
		btn.connect("focus_entered", self, "_on_button_focus_entered", [btn])
		btn.connect("focus_exited", self, "_on_button_focus_exited", [btn])
		if btn.name == "Start":
			btn.get_child(0).show()
		else:
			btn.get_child(0).hide()

func _on_button_focus_entered(btn):
	btn.get_node("Arrow").show()

func _on_button_focus_exited(btn):
	btn.get_node("Arrow").hide()

func _on_Start_pressed():
	get_tree().change_scene("res://Gameplay.tscn")

func _on_Exit_pressed():
	get_tree().quit()
