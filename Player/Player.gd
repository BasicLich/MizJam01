extends KinematicBody2D

const CONTROLS = {
	"up": "ui_up",
	"down": "ui_down",
	"left": "ui_left",
	"right": "ui_right",
	"jump": "jump",
	"attack": "attack"
}

onready var input_controls = CONTROLS

const WindGust = preload("res://Player/WindGust.tscn")

const SNAP = Vector2(0, 12)
const MAX_FALL_SPEED = 148
const FAN_STRIKE_RECOIL_SPEED = 264
const FAN_STRIKE_VERTICAL_RECOIL_SPEED = 164
onready var gravity = 10
onready var speed = 72
onready var jump_speed = 200
onready var jump_grace_timer = $JumpGraceTimer

onready var velocity = Vector2()
onready var face_direction = 1
onready var strike_dir = Vector2()

onready var hp = 3

onready var state_machine = $StateMachine
onready var animation_player = $AnimationPlayer
onready var body = $Body
onready var fan_strike_timer = $FanStrikeTimer
onready var wind_slash_spawn = $Body/WindSlashSpawn
onready var wind_slash_spawn_down = $Body/WindSlashSpawnDown
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var death_timer = $DeathTimer

onready var debug_points = []
onready var current_debug_point = 0

func _physics_process(_delta):
	if state_machine.state == state_machine.States.DEAD:
		return
	
	# Debug warping, TODO disable for release
	if Input.is_action_just_pressed("warp"):
		if debug_points.empty():
			for each in get_tree().get_nodes_in_group("DebugPoints"):
				if each.is_warp_enabled():
					debug_points.append(each)
		if not debug_points.empty():
			global_position = debug_points[current_debug_point].global_position
			current_debug_point += 1
			current_debug_point %= debug_points.size()
	
	if state_machine.state == state_machine.States.FAN_STRIKE:
		velocity.x *= 0.9
	else:
		velocity.x = 0
	
	# Gravity
	velocity.y += get_gravity()
	
	# Stop vertical movement during fan strike
	if state_machine.state == state_machine.States.FAN_STRIKE:
		if strike_dir == Vector2.DOWN:
			velocity.x = 0
		else:
			velocity.y = 0
	
	# Movement
	if can_move():
		if Input.is_action_pressed(input_controls["left"]):
			velocity.x -= get_speed()
		if Input.is_action_pressed(input_controls["right"]):
			velocity.x += get_speed()
		if velocity.x != 0:
			face_direction = sign(velocity.x)
		body.scale.x = face_direction
		if Input.is_action_just_pressed(input_controls["attack"]):
			if can_attack():
				fan_strike()
	
	# Jump
	if Input.is_action_just_pressed(input_controls["jump"]):
		if can_jump():
			jump()
	
	if state_machine.state == state_machine.States.JUMP \
			or strike_dir == Vector2.DOWN:
		velocity.y = move_and_slide(velocity, Vector2.UP, true).y
	else:
		velocity.y = move_and_slide_with_snap(velocity, SNAP, Vector2.UP, true).y
	
	# Limit fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func can_move() -> bool:
	return state_machine.is_in_moving_state()

func can_jump() -> bool:
	return can_move() and (is_on_floor() or is_jump_grace_active())

func jump():
	velocity.y = -get_jump_speed()
	state_machine.set_state(state_machine.States.JUMP)

func can_attack():
	return state_machine.state != state_machine.States.FAN_STRIKE \
		and attack_cooldown_timer.is_stopped()

func fan_strike():
	fan_strike_timer.start()
	attack_cooldown_timer.start()
	var wind_slash = WindGust.instance()
	get_parent().add_child(wind_slash)
	if Input.is_action_pressed(input_controls["down"]):
		strike_dir = Vector2.DOWN
		wind_slash.global_position = wind_slash_spawn_down.global_position
		wind_slash.rotation = deg2rad(135)
		var slash_speed = 172
		wind_slash.set_velocity(0, slash_speed)
		velocity.x = 0
		velocity.y = -FAN_STRIKE_VERTICAL_RECOIL_SPEED
	else:
		wind_slash.global_position = wind_slash_spawn.global_position
		var slash_speed = 212
		if face_direction == 1:
			strike_dir = Vector2.RIGHT
			velocity.x = -FAN_STRIKE_RECOIL_SPEED
			wind_slash.rotation = deg2rad(45)
			wind_slash.set_velocity(slash_speed, 0)
		else:
			strike_dir = Vector2.LEFT
			velocity.x = FAN_STRIKE_RECOIL_SPEED
			wind_slash.rotation = deg2rad(-135)
			wind_slash.set_velocity(-slash_speed, 0)
	state_machine.set_state(state_machine.States.FAN_STRIKE)

func damage(amount: int):
	if state_machine.state == state_machine.States.DEAD:
		return
	if amount < 0:
		amount = 0
	hp -= amount
	if hp <= 0:
		hp = 0
		state_machine.set_state(state_machine.States.DEAD)

func collect_coin():
	Globals.coins_collected += 1
	# TODO: coin sfx

func finish_level():
	get_parent().finish_level()
	state_machine.set_state(state_machine.States.WIN)

func get_gravity() -> float:
	var g = gravity
	# Floaty jump
	if not is_on_floor() and velocity.y < -32:
		g = gravity
	elif not is_on_floor() and abs(velocity.y) <= 32:
		g *= 0.6
	else:
		g *= 0.8
	
	return g

func get_speed() -> float:
	return speed

func get_jump_speed() -> float:
	return jump_speed

func is_on_ground() -> bool:
	return is_on_floor()

func is_jump_grace_active() -> bool:
	return not jump_grace_timer.is_stopped()

func _on_FanStrikeTimer_timeout():
	state_machine.set_state(state_machine.States.FALL)

func _on_DeathTimer_timeout():
	# TODO: checkpoints?
	get_tree().reload_current_scene()
