extends Control

export(String, FILE, "*.tscn") var start_scene := String()

func _ready() -> void:
	pass


func _on_ButtonStart_pressed() -> void:
	get_tree().change_scene(start_scene)


func _on_ButtonCredits_pressed() -> void:
	pass # Replace with function body.


func _on_ButtonExit_pressed() -> void:
	pass # Replace with function body.
