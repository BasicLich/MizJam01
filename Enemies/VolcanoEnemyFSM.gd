extends "res://StateMachine.gd"

# States: IDLE, WALK, PUSHED
enum States {IDLE, WALK, PUSHED, ATTACK, DEAD}

func _ready():
	call_deferred("set_state", States.IDLE)

func _state_logic(_delta):
	if state == States.PUSHED:
		actor.velocity.x *= 0.9
	elif state == States.ATTACK:
		actor.face_player()
	elif state == States.WALK:
		if actor.velocity.x > 0 and !actor.right_floor_raycast.is_colliding():
			actor.velocity.x = 0
			set_state(States.IDLE)
		if actor.velocity.x < 0 and !actor.left_floor_raycast.is_colliding():
			actor.velocity.x = 0
			set_state(States.IDLE)
	
func _state_transition(_delta):
	if state == States.IDLE:
		if actor.is_player_in_range() and actor.can_attack():
			set_state(States.ATTACK)
		elif actor.velocity.x != 0:
			set_state(States.WALK)
	elif state == States.WALK:
		if actor.is_player_in_range() and actor.can_attack():
			set_state(States.ATTACK)
		elif actor.velocity.x == 0:
			set_state(States.IDLE)

func _enter_state(new_state, old_state):
	match new_state:
		States.IDLE:
			actor.animation_player.play("walk")
		States.WALK:
			actor.animation_player.play("walk")
		States.PUSHED:
			actor.animation_player.play("rest")
			actor.pushed_duration_timer.start()
		States.ATTACK:
			actor.animation_player.play("attack")
		States.DEAD:
			actor.animation_player.stop()
