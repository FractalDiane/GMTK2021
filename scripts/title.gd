extends Control

export(String, FILE, "*.tscn") var start_scene := String()

func _ready() -> void:
	pass


func _on_ButtonStart_pressed() -> void:
	$AnimationPlayer.play("wipe_start")


func _on_ButtonCredits_pressed() -> void:
	pass # Replace with function body.


func _on_ButtonExit_pressed() -> void:
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "wipe_start":
		get_tree().change_scene(start_scene)
