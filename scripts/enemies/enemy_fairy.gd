extends "res://scripts/enemies/enemy.gd"

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
	var target := Vector2(rand_range(15, 345), get_position().y + 15)
	set_position(target)
	hoard_target = get_tree().current_scene.get_closest_horde(target)
	
	
func _on_AreaSteal_area_entered(area: Area2D) -> void:
	if not stole_gold and not stealing_gold:
		stealing_gold = true
		$TimerTeleport.stop()
		movement = Vector2.ZERO
		$TimerSteal.start()


func _on_TimerSteal_timeout() -> void:
	stealing_gold = false
	movement = Vector2(-1 if randf() > 0.5 else 1, 0)
	speed = 150.0
	stole_gold = true
