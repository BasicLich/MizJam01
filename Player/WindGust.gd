extends Node2D

onready var velocity = Vector2()
onready var life_timer = $LifeTimer

func _process(delta):
	position.x += velocity.x * delta
	position.y += velocity.y * delta
	
	velocity *= 0.88
	modulate.a = clamp(life_timer.time_left / 0.6, 0, 1)

func set_velocity(x: float, y: float):
	velocity.x = x
	velocity.y = y

func _on_LifeTimer_timeout():
	queue_free()
