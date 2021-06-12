extends Node2D

signal closed()

onready var box := $CanvasLayer/Box as NinePatchRect
onready var button_left := $CanvasLayer/ButtonLeft as TextureButton
onready var button_right := $CanvasLayer/ButtonRight as TextureButton

var page := 0

func _ready() -> void:
	pass
	
	
func change_page(value: int) -> void:
	page = value
	for i in range(box.get_child_count()):
		box.get_child(i).set_visible(i == value)


func _on_ButtonLeft_pressed() -> void:
	change_page(max(page - 1, 0))
	button_left.set_disabled(page == 0)
	button_right.set_disabled(page == box.get_child_count() - 1)


func _on_ButtonRight_pressed() -> void:
	change_page(min(page + 1, box.get_child_count() - 1))
	button_left.set_disabled(page == 0)
	button_right.set_disabled(page == box.get_child_count() - 1)


func _on_ButtonCheck_pressed() -> void:
	emit_signal("closed")
	queue_free()
