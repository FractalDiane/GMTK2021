extends "res://scripts/enemies/enemy.gd"

var hoard_target: Area2D

func _ready() -> void:
	hoard_target = get_tree().current_scene.get_closest_horde(get_position())
	
	
func _physics_process(delta: float) -> void:
	if not stealing_gold and not stole_gold:
		var dir := get_position().direction_to(hoard_target.get_position())
		move_and_slide(dir * speed)
	else:
		move_and_slide(movement * speed)
	
	
func _on_AreaSteal_area_entered(area: Area2D) -> void:
	if not stole_gold and not stealing_gold and area.is_in_group("Horde"):
		stealing_gold = true
		movement = Vector2.ZERO
		$TimerSteal.start()
		$Sprite.play("steal")
		area.get_node("SoundSteal").play()


func _on_TimerSteal_timeout() -> void:
	._on_TimerSteal_timeout()
	stealing_gold = false
	movement = Vector2(-1 if randf() > 0.5 else 1, -1)
	speed = 200.0
	stole_gold = true
