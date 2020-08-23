extends KinematicBody2D

const Flame = preload("res://Obstacles/Flame.tscn")

const MAX_FALL_SPEED = 162
onready var player_detected = false
onready var face_direction = 1
onready var gravity = 10
onready var speed = 16
onready var push_speed = 128
onready var velocity = Vector2()

onready var body = $Body
onready var state_machine = $StateMachine
onready var walk_timer = $WalkTimer
onready var walk_duration_timer = $WalkDurationTimer
onready var animation_player = $AnimationPlayer
onready var pushed_duration_timer = $PushedDurationTimer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var flame_spawn = $FlameSpawn
onready var stomp_sfx = $StompSound
onready var left_floor_raycast = $LeftFloorRay
onready var right_floor_raycast = $RightFloorRay
onready var death_sfx = $DeathSound

onready var player = null

func _ready():
	player = get_tree().get_nodes_in_group("Players")[0]
	walk_timer.start()

func _physics_process(delta):
	# Gravity
	velocity.y += get_gravity()
	
	# Movement
	if velocity.x != 0:
		face_direction = sign(velocity.x)
	body.scale.x = face_direction
	
	velocity.y = move_and_slide(velocity, Vector2.UP, true).y
	
	# Limit fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func attack():
	attack_cooldown_timer.start()
	state_machine.set_state(state_machine.States.IDLE)
	for i in range(2):
		spawn_flame()
		yield(get_tree().create_timer(0.2), "timeout")

func play_stomp_sound():
	stomp_sfx.play()

func spawn_flame():
	var flame = Flame.instance()
	get_parent().add_child(flame)
	flame.global_position = flame_spawn.global_position
	var speed = rand_range(32, 64)
	flame.velocity.x = speed * face_direction
	flame.velocity.y = -64

func can_attack():
	return attack_cooldown_timer.is_stopped() and !is_dead()

func face_player():
	if player == null:
		player = get_tree().get_nodes_in_group("Players")[0]
	var dir
	if player.global_position.x < global_position.x:
		dir = -1
	else:
		dir = 1
	if face_direction != dir:
		turn()

func _on_DamageArea_body_entered(body):
	if body == self:
		return
	
	if body.has_method("damage"):
		body.damage(10)

func _on_PlayerDetect_body_entered(body):
	if body.is_in_group("Players"):
		player_detected = true

func _on_PlayerDetect_body_exited(body):
	if body.is_in_group("Players"):
		player_detected = false

func is_player_in_range():
	return player_detected

func wind_gust_touched(gust):
	if is_dead():
		return
	
	velocity.x = push_speed * sign(gust.velocity.x)
	state_machine.set_state(state_machine.States.PUSHED)

func damage(amount: int, ignore_immunity: bool = false):
	if is_dead():
		return
	
	death_sfx.play()
	$Particles.emitting = false
	body.hide()
	state_machine.set_state(state_machine.States.DEAD)

func get_gravity() -> float:
	var g = gravity
	g *= 0.8
	
	return g

func turn():
	face_direction *= -1

func can_walk() -> bool:
	return state_machine.state != state_machine.States.PUSHED \
		and state_machine.state != state_machine.States.ATTACK and !is_dead()

func is_dead():
	return state_machine.state == state_machine.States.DEAD

func _on_WalkTimer_timeout():
	if is_dead():
		return
	
	if can_walk():
		if randf() < 0.5:
			turn()
		velocity.x = speed * face_direction
		state_machine.set_state(state_machine.States.WALK)
		walk_duration_timer.start(rand_range(0.2, 1))
	walk_timer.start(rand_range(2, 5))

func _on_WalkDurationTimer_timeout():
	velocity.x = 0
	if can_walk():
		state_machine.set_state(state_machine.States.IDLE)

func _on_PushedDurationTimer_timeout():
	state_machine.set_state(state_machine.States.IDLE)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		attack()

func _on_AttackCooldownTimer_timeout():
	pass

func _on_DeathSound_finished():
	queue_free()
