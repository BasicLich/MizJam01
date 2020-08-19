extends "res://StateMachine.gd"

enum States {IDLE, RUN, JUMP, FALL}

const MOVING_STATES = [States.IDLE, States.RUN, States.JUMP, States.FALL]

func _ready():
	call_deferred("set_state", States.IDLE)

func _state_logic(_delta):
	match state:
		States.IDLE:
			actor.idle_state()
		States.RUN:
			actor.run_state()
		States.JUMP:
			actor.jump_state()
		States.FALL:
			actor.fall_state()

func _state_transition(_delta):
	if state == States.IDLE:
		if actor.is_on_ground():
			if actor.velocity.x != 0:
				set_state(States.RUN)
		else:
			if actor.velocity.y > 0:
				set_state(States.FALL)
	elif state == States.RUN:
		if actor.is_on_ground():
			if actor.velocity.x == 0:
				set_state(States.IDLE)
		else:
			if actor.velocity.y > 0:
				set_state(States.FALL)
	elif state == States.JUMP:
		if actor.is_on_ground():
			set_state(States.IDLE)
		elif actor.velocity.y > 0:
			set_state(States.FALL)
	elif state == States.FALL:
		if actor.velocity.y == 0:
			set_state(States.IDLE)

func _enter_state(new_state, old_state):
	match new_state:
		States.IDLE:
			actor.animation_player.play("idle")
		States.RUN:
			actor.animation_player.play("run")
		States.JUMP:
			actor.animation_player.play("jump")
		States.FALL:
			actor.animation_player.play("fall")
			if old_state == States.IDLE or old_state == States.RUN:
				actor.jump_grace_timer.start()

func is_in_moving_state() -> bool:
	return state in MOVING_STATES
