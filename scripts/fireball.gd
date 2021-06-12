extends RigidBody2D

func _process(delta: float) -> void:
	var pos := get_position()
	if pos.x < -30 or pos.x > 670 or pos.y < -30 or pos.y > 390:
		queue_free()
