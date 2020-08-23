extends Node2D

onready var buttons = $Buttons
onready var resume_button = $Buttons/Resume
onready var blip_sfx = $Blip
onready var can_pause = true

func _ready():
	buttons.get_child(0).grab_focus()
	for btn in buttons.get_children():
		btn.connect("focus_entered", self, "_on_button_focus_entered", [btn])
		btn.connect("focus_exited", self, "_on_button_focus_exited", [btn])
		if btn.name == "Resume":
			btn.get_child(0).show()
		else:
			btn.get_child(0).hide()
	
	hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if visible:
			unpause_game()
		elif can_pause:
			pause_game()

func _on_button_focus_entered(btn):
	btn.get_node("Arrow").show()
	blip_sfx.play()

func _on_button_focus_exited(btn):
	btn.get_node("Arrow").hide()

func pause_game():
	show()
	resume_button.grab_focus()
	get_tree().paused = true

func unpause_game():
	hide()
	get_tree().paused = false

func _on_Quit_pressed():
	get_tree().paused = false
	GlobalSounds.play_blip_confirm()
	get_tree().change_scene("res://Main.tscn")

func _on_Resume_pressed():
	unpause_game()
