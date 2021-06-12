extends KinematicBody2D

const fireball_prefab := preload("res://prefabs/fireball.tscn")
const fireball_speed := 50000.0

export(float) var speed := 100.0
export(float) var head_rotation_speed := 40.0

export(float) var cooldown := 1.0

var can_fire_left := true
var can_fire_right := true

var power_balance := 0

var moving := false

onready var head_left := $SpriteHead1 as AnimatedSprite
onready var head_right := $SpriteHead2 as AnimatedSprite
onready var sound_walk := $SoundWalk as AudioStreamPlayer
onready var timer_cooldown_left := $TimerCooldownLeft as Timer
onready var timer_cooldown_right := $TimerCooldownRight as Timer


func _ready() -> void:
	pass # Replace with function body.
	
	
func _process(delta: float) -> void:
	var fire_h_left := Input.is_action_pressed("fire_h_left")
	var fire_v_left := Input.is_action_pressed("fire_v_left")
	var fire_h_right := Input.is_action_pressed("fire_h_right")
	var fire_v_right := Input.is_action_pressed("fire_v_right")
	
	if can_fire_left and (fire_h_left or fire_v_left):
		fire(false, fire_h_left, fire_v_left, delta)
	if can_fire_right and (fire_h_right or fire_v_right):
		fire(true, fire_h_right, fire_v_right, delta)
		
	if moving and not sound_walk.is_playing():
		sound_walk.play()
	elif not moving and sound_walk.is_playing():
		sound_walk.stop()
		
	if Input.is_action_just_pressed("power_balance_left"):
		power_balance = max(power_balance - 1, -2)
	if Input.is_action_just_pressed("power_balance_right"):
		power_balance = min(power_balance + 1, 2)
		

func _physics_process(_delta: float) -> void:
	var body_movement := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	var final_movement := Vector2(body_movement, 0.0) * speed
	move_and_slide(final_movement)
	moving = final_movement != Vector2.ZERO


func fire(right: bool, hor: bool, ver: bool, delta: float) -> void:
	var target: AnimatedSprite = head_right if right else head_left
	var fireball := fireball_prefab.instance() as RigidBody2D
	fireball.set_position(target.get_global_position())
		
	var vector := Vector2.UP.rotated(deg2rad(-45.0))
	vector = vector.rotated(deg2rad(-45.0) * float(not ver) + deg2rad(45.0) * float(not hor))
	if right:
		vector.x *= -1.0
	fireball.linear_velocity = vector * fireball_speed * delta
	get_tree().get_root().add_child(fireball)
	
	if right:
		can_fire_right = false
		timer_cooldown_right.set_wait_time(cooldown)
		timer_cooldown_right.start()
	else:
		can_fire_left = false
		timer_cooldown_left.set_wait_time(cooldown)
		timer_cooldown_left.start()


func _on_TimerCooldownLeft_timeout() -> void:
	can_fire_left = true


func _on_TimerCooldownRight_timeout() -> void:
	can_fire_right = true
