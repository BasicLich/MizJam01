extends KinematicBody2D

const CONTROLS = {
	"up": "ui_up",
	"down": "ui_down",
	"left": "ui_left",
	"right": "ui_right",
	"jump": "ui_accept"
}

onready var input_controls = CONTROLS

const MAX_FALL_SPEED = 148
onready var gravity = 10
onready var speed = 72
onready var jump_speed = 200
onready var jump_grace_timer = $JumpGraceTimer

onready var velocity = Vector2()
onready var face_direction = 1

onready var state_machine = $StateMachine
onready var animation_player = $AnimationPlayer
onready var body = $Body

onready var jumpSfx = $JumpSfx

func _ready():
	pass

func _physics_process(_delta):
	velocity.x = 0
	
	# Gravity
	velocity.y += get_gravity()
	
	# Movement
	if can_move():
		if Input.is_action_pressed(input_controls["left"]):
			velocity.x -= get_speed()
		if Input.is_action_pressed(input_controls["right"]):
			velocity.x += get_speed()
		if velocity.x != 0:
			face_direction = sign(velocity.x)
		body.scale.x = face_direction
	
	# Jump
	if Input.is_action_just_pressed(input_controls["jump"]):
		if can_jump():
			jump()
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	
	# Limit fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func idle_state():
	pass

func run_state():
	pass

func jump_state():
	pass

func fall_state():
	pass

func can_move() -> bool:
	return state_machine.is_in_moving_state()

func can_jump() -> bool:
	return is_on_floor() or is_jump_grace_active()

func jump():
	velocity.y = -get_jump_speed()
	state_machine.set_state(state_machine.States.JUMP)

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
