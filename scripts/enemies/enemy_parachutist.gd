extends "res://scripts/enemies/enemy.gd"

var falling := true

func _ready() -> void:
	speed = rand_range(15.0, 60.0)
	
	
func _process(delta: float) -> void:
	if falling and position.y >= 288:
		
		var horde_pos: Vector2 = get_tree().current_scene.get_closest_horde(position).position
		
		movement = Vector2(1 if horde_pos.x > position.x else -1, 0)
		$Sprite.play("walk")
		falling = false
	

func _physics_process(delta: float) -> void:
	move_and_slide(movement * speed)


func _on_AreaSteal_area_entered(area: Area2D) -> void:
	if not stole_gold and not stealing_gold and area.is_in_group("Horde"):
		stealing_gold = true
		movement = Vector2.ZERO
		timer_steal.start()


func _on_TimerSteal_timeout() -> void:
	._on_TimerSteal_timeout()
	stealing_gold = false
	stole_gold = true
	speed = 80.0
	$Sprite.play("steal")
	movement = Vector2.UP
