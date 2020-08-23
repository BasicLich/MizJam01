extends Node2D

onready var animation_player = $AnimationPlayer
onready var input_delay_timer = $InputDelayTimer
onready var prompt = $Window/Prompt
onready var start_delay_timer = $StartDelay

onready var can_read_input = false

func _ready():
	prompt.hide()

func _input(event):
	if can_read_input:
		if event is InputEventKey:
			if event.pressed:
				Globals.next_level()
				can_read_input = false

func show_ui():
	start_delay_timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "show_ui":
		input_delay_timer.start()

func _on_InputDelayTimer_timeout():
	can_read_input = true
	prompt.show()

func _on_StartDelay_timeout():
	animation_player.play("show_ui")
