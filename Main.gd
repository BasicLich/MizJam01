extends Node2D

onready var buttons = $Buttons

func _ready():
	OS.window_size = Vector2(800, 600)
	# Center the window after resizing
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	buttons.get_child(0).grab_focus()
	for btn in buttons.get_children():
		btn.connect("focus_entered", self, "_on_button_focus_entered", [btn])
		btn.connect("focus_exited", self, "_on_button_focus_exited", [btn])
		if btn.name == "Start":
			btn.get_child(0).show()
		else:
			btn.get_child(0).hide()

func _process(_delta):
	pass

func _on_button_focus_entered(btn):
	btn.get_node("Arrow").show()

func _on_button_focus_exited(btn):
	btn.get_node("Arrow").hide()

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/Level01.tscn")

func _on_Exit_pressed():
	get_tree().quit()
