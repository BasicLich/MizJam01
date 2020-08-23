extends Node2D

export (Vector2) var direction = Vector2.UP
export (int) var bounce_force = 320
onready var animation_player = $AnimationPlayer
onready var spring_sfx = $SpringSound

func _ready():
	$Sprite.frame = 0

func _on_DetectArea_body_entered(body):
	if body.has_method("spring_jump"):
		body.spring_jump(bounce_force, direction)
		animation_player.play("bounce", -1, 1.5)
		spring_sfx.play()
