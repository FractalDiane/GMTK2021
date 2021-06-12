extends KinematicBody2D

var movement := Vector2.DOWN
var speed := 30.0
var stealing_gold := false
var stole_gold := false
var dead := false

onready var timer_steal := $TimerSteal as Timer


func _process(delta: float) -> void:
	if stole_gold and is_offscreen():
		get_tree().current_scene.lose_gold()
		queue_free()


func is_offscreen() -> bool:
	var pos := get_position()
	return pos.x < -30 or pos.x > 670 or pos.y < -30 or pos.y > 390
	
	
func _die() -> void:
	$SoundDie.play()
	$Sprite.play("die")
	speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	hide()
	
	dead = true
	$TimerDie.start()


func _on_Hitbox_body_entered(body: Node) -> void:
	body.queue_free()
	_die()
	
	
func _on_Hitbox_area_entered(area: Area2D) -> void:
	_die()

func _on_TimerDie_timeout() -> void:
	queue_free()
