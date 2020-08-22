extends Node2D

func _on_PlayerDetect_body_entered(body):
	if body.has_method("finish_level"):
		body.finish_level()
