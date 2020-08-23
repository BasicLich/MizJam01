extends Node2D

export (int, 0, 2) var coin_index = 0

signal collected(i)

onready var picked_up = false

func _on_Area_body_entered(body):
	if body.has_method("collect_coin") and not picked_up:
		picked_up = true
		body.collect_coin()
		pickup()

func pickup():
	emit_signal("collected", coin_index)
	$Pickup.play()
	$CoinSprite.hide()
	$Particles.emitting = true
	$DeathTimer.start()

func _on_DeathTimer_timeout():
	queue_free()
