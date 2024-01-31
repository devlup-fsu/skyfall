extends RigidBody3D

signal player_killed

func _on_body_entered(body):
	if body.is_in_group("player") and linear_velocity.y <= -1:
		player_killed.emit()
