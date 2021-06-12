extends "res://scripts/enemies/enemy.gd"

var falling := true

func _ready() -> void:
	speed = rand_range(15.0, 60.0)
	
	
func _process(delta: float) -> void:
	if falling and position.y >= 288:
		movement = Vector2(1 if randf() > 0.5 else -1, 0)
		$Sprite.play("walk")
		falling = false
	

func _physics_process(delta: float) -> void:
	move_and_slide(movement * speed)


func _on_AreaSteal_area_entered(area: Area2D) -> void:
	if not stole_gold and not stealing_gold:
		stealing_gold = true
		movement = Vector2.ZERO
		timer_steal.start()


func _on_TimerSteal_timeout() -> void:
	stealing_gold = false
	stole_gold = true
	speed = 80.0
	movement = Vector2.UP
