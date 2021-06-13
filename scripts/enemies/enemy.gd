extends KinematicBody2D

var movement := Vector2.DOWN
var speed := 30.0
var stealing_gold := false
var stole_gold := false
var dead := false

onready var timer_steal := $TimerSteal as Timer


func _ready() -> void:
	$Sprite.connect("animation_finished", self, "_on_Sprite_animation_finished")


func _process(delta: float) -> void:
	if stole_gold and is_offscreen():
		get_tree().current_scene.lose_gold()
		queue_free()


func is_offscreen() -> bool:
	var pos := get_position()
	return pos.x < -30 or pos.x > 670 or pos.y < -30 or pos.y > 390
	
	
func _die(play_sound: bool = true) -> void:
	if play_sound:
		$SoundDie.play()
	$Sprite.play("die")
	speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	
	dead = true
	$TimerDie.start()
	
	
func _on_TimerSteal_timeout() -> void:
	$SoundSteal.play()
	
	
func _on_Sprite_animation_finished() -> void:
	if $Sprite.animation == "die":
		hide()


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("Projectile"):
		body.queue_free()
		_die()
	
	
func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectile"):
		_die()

func _on_TimerDie_timeout() -> void:
	queue_free()
