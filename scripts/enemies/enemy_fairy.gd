extends "res://scripts/enemies/enemy.gd"

const poof_prefab := preload("res://prefabs/poof.tscn")

var hoard_target: Area2D

func _ready() -> void:
	hoard_target = get_tree().current_scene.get_closest_horde(get_position())
	
	$TimerTeleport.set_wait_time(rand_range(2.0, 4.0))
	$TimerTeleport.start()
	
	
func _physics_process(delta: float) -> void:
	if not stealing_gold and not stole_gold:
		var dir := get_position().direction_to(hoard_target.get_position())
		move_and_slide(dir * speed)
	else:
		move_and_slide(movement * speed)
	
	
func _on_TimerTeleport_timeout() -> void:
	$SoundTeleport.set_pitch_scale(rand_range(1.0, 1.4))
	$SoundTeleport.play()
	var target := Vector2(rand_range(15, 345), get_position().y + 15)
	
	var poof1 := poof_prefab.instance() as AnimatedSprite
	poof1.set_position(get_position())
	get_tree().get_root().add_child(poof1)
	var poof2 := poof_prefab.instance() as AnimatedSprite
	poof2.set_position(target)
	get_tree().get_root().add_child(poof2)
	
	set_position(target)
	hoard_target = get_tree().current_scene.get_closest_horde(target)
	
	
func _on_AreaSteal_area_entered(area: Area2D) -> void:
	if not stole_gold and not stealing_gold and area.is_in_group("Horde"):
		stealing_gold = true
		$TimerTeleport.stop()
		movement = Vector2.ZERO
		$TimerSteal.start()
		$Sprite.play("steal")
		area.get_node("SoundSteal").play()
		
		
func _die(play_sound: bool = true) -> void:
	._die(play_sound)
	$TimerTeleport.stop()


func _on_TimerSteal_timeout() -> void:
	._on_TimerSteal_timeout()
	stealing_gold = false
	movement = Vector2(-1 if randf() > 0.5 else 1, -1)
	speed = 150.0
	stole_gold = true
