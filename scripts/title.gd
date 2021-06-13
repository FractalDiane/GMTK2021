extends Control

export(String, FILE, "*.tscn") var start_scene := String()

var credits_open := false


func _process(delta: float) -> void:
	if credits_open and (Input.is_action_just_pressed("flip") or Input.is_action_just_pressed("cancel_credits")):
		$Credits.hide()
		$Title.show()
		$Buttons.show()
		credits_open = false


func _on_ButtonStart_pressed() -> void:
	$AnimationPlayer.play("wipe_start")


func _on_ButtonCredits_pressed() -> void:
	$Title.hide()
	$Buttons.hide()
	$Credits.show()
	credits_open = true


func _on_ButtonExit_pressed() -> void:
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "wipe_start":
		get_tree().change_scene(start_scene)
