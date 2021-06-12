extends Control
class_name GameUI

signal animation_finished()

onready var text_timer := $TextTimer as Label

func _ready() -> void:
	pass
	
	
func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)
	
	
func set_timer_text(time_remaining: float) -> void:
	text_timer.set_text(str(ceil(time_remaining)))
	

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("animation_finished")
	
