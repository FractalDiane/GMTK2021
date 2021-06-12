extends KinematicBody2D

const fireball_prefab := preload("res://prefabs/fireball.tscn")
const fireball_speed := 50000.0

export(float) var speed := 100.0
export(float) var head_rotation_speed := 40.0

export(float) var cooldown := 1.0

var can_fire_left := true
var can_fire_right := true

var moving := false
var flipped := false

onready var sprite_body := $SpriteBody as AnimatedSprite
onready var head_left := $SpriteHead1 as AnimatedSprite
onready var head_right := $SpriteHead2 as AnimatedSprite
onready var lightning := $LightningBeam as Area2D
onready var sound_walk := $SoundWalk as AudioStreamPlayer
onready var sound_lightning := $SoundShootRight as AudioStreamPlayer
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
		lightning.show()
		lightning.get_node("CollisionShape2D").set_disabled(false)
		var rot := -45 + 45 * float(not fire_v_right) - 45 * float(not fire_h_right)
		lightning.set_rotation_degrees(rot)
		head_right.set_rotation_degrees(rot)
		head_right.play("shoot")
	else:
		lightning.hide()
		lightning.get_node("CollisionShape2D").set_disabled(true)
		head_right.set_rotation_degrees(0)
		#fire(true, fire_h_right, fire_v_right, delta)
		
	if fire_h_right or fire_v_right:
		if not sound_lightning.is_playing():
			sound_lightning.play()
	elif sound_lightning.is_playing():
		sound_lightning.stop()
		
	if moving and not sound_walk.is_playing():
		sound_walk.play()
	elif not moving and sound_walk.is_playing():
		sound_walk.stop()
		
	sprite_body.play(("walk" if not flipped else "walk_flipped") if moving else "idle" if not flipped else "idle_flipped")
	
	if Input.is_action_just_pressed("flip"):
		$SoundFlip.play()
		$AnimationPlayer.play("flip")
		

func _physics_process(_delta: float) -> void:
	var body_movement := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	var final_movement := Vector2(body_movement, 0.0) * speed
	move_and_slide(final_movement)
	moving = final_movement != Vector2.ZERO


func fire(right: bool, hor: bool, ver: bool, delta: float) -> void:
	var target: AnimatedSprite = head_right if right else head_left
	if not right:
		var fireball := fireball_prefab.instance() as RigidBody2D
		fireball.set_position(target.get_global_position())
			
		var vector := Vector2.UP.rotated(deg2rad(-45.0))
		var rot := deg2rad(-45.0) * float(not ver) + deg2rad(45.0) * float(not hor)
		vector = vector.rotated(rot)
		head_left.set_rotation(rot + deg2rad(45))
		fireball.linear_velocity = vector * fireball_speed * delta
		get_tree().get_root().add_child(fireball)
		
		head_left.play("shoot")
		$SoundShootLeft.set_pitch_scale(rand_range(1.3, 1.5))
		$SoundShootLeft.play()
		
		can_fire_left = false
		timer_cooldown_left.set_wait_time(cooldown)
		timer_cooldown_left.start()
	
	#if right:
	#	pass
	#if not right:
		
	
	#if right:
	#	can_fire_right = false
	#	timer_cooldown_right.set_wait_time(cooldown)
	#	timer_cooldown_right.start()
	#if not right:
	
	
func flip_heads(flip: bool) -> void:
	var pos1 := head_left.get_position()
	head_left.set_position(head_right.get_position())
	head_right.set_position(pos1)
	head_left.flip_h = not head_left.flip_h
	head_right.flip_h = not head_right.flip_h
	
	flipped = not flipped
		


func _on_TimerCooldownLeft_timeout() -> void:
	can_fire_left = true


func _on_TimerCooldownRight_timeout() -> void:
	can_fire_right = true


func _on_SpriteHead1_animation_finished() -> void:
	if head_left.animation == "shoot":
		head_left.play("idle")


func _on_SpriteHead2_animation_finished() -> void:
	if head_right.animation == "shoot":
		head_right.play("idle")
