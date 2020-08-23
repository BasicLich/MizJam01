extends Node2D

func _on_Area_body_entered(body):
	if body.has_method("collect_coin"):
		body.collect_coin()
		# TODO: coin sfx
		queue_free()
