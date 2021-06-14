extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
		
	if Input.is_action_just_pressed("pause"):
		_on_ButtonResume_pressed()
		

func _on_ButtonResume_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_ButtonExit_pressed() -> void:
	get_tree().quit()
