extends Control
class_name GameUI

signal animation_finished()

onready var text_timer := $CanvasLayer/TextTimer as Label

func _ready() -> void:
	pass
	
	
func set_gold_count(count: int) -> void:
	$CanvasLayer/TextGold.set_text("%s Gold Left" % count)
	
	
func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)
	
	
func set_timer_text(time_remaining: float) -> void:
	text_timer.set_text(str(floor(time_remaining)))
	
	
func set_highscore(score: float) -> void:
	$CanvasLayer/TextTimer2.set_text("Best: %s" % score)
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "start":
		emit_signal("animation_finished")


func _on_ButtonRetry_pressed() -> void:
	$CanvasLayer/EndButtons.hide()
	var player := get_tree().current_scene.get_node("Player")
	player.can_move = true
	player.get_node("SpriteHead1").play("idle")
	player.get_node("SpriteHead2").play("idle")
	get_tree().current_scene.get_node("Music").play()
	get_tree().current_scene.start_level()


func _on_ButtonQuit_pressed() -> void:
	$CanvasLayer/EndButtons.hide()
	get_tree().current_scene.get_node("AnimationPlayer").play("start_level")
	$TimerQuit.start()

func _on_TimerQuit_timeout() -> void:
	get_tree().change_scene("res://scenes/title.tscn")
	queue_free()
