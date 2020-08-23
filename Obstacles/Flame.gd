extends KinematicBody2D

onready var death_timer = $DeathTimer
onready var life_timer = $LifeTimer
onready var can_damage = true

onready var Flame = load("res://Obstacles/Flame.tscn")

const MAX_FALL_SPEED = 162
onready var gravity = 4
onready var push_speed = 224
onready var velocity = Vector2()

func _physics_process(delta):
	# Gravity
	velocity.y += get_gravity()

	# Movement
	velocity = move_and_slide(velocity, Vector2.UP, true)
	if is_on_floor():
		velocity.x *= 0.92
		if life_timer.is_stopped():
			life_timer.start()
	
	# Limit fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func wind_gust_touched(gust):
	velocity.x = push_speed * sign(gust.velocity.x)

func get_gravity() -> float:
	var g = gravity
	g *= 0.8
	return g

func _on_PlayerDetect_body_entered(body):
	if body.is_in_group("Players") and can_damage:
		can_damage = false
		body.damage(1)
		$Particles.emitting = false
		$Sprite.hide()
		death_timer.start()

func _on_DeathTimer_timeout():
	queue_free()

func _on_LifeTimer_timeout():
	can_damage = false
	$Particles.emitting = false
	$Sprite.hide()
	death_timer.start()
