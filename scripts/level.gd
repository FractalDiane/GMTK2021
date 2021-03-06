extends Node2D

const horde_prefab := preload("res://prefabs/horde.tscn")
const game_ui_prefab := preload("res://prefabs/game_ui.tscn")
const pause_menu_prefab := preload("res://prefabs/pause_menu.tscn")

const enemy_prefab_parachutist := preload("res://prefabs/enemies/enemy_parachutist.tscn")
const enemy_prefab_bat := preload("res://prefabs/enemies/enemy_bat.tscn")
const enemy_prefab_fairy := preload("res://prefabs/enemies/enemy_fairy.tscn")

export(Resource) var level_data_test

enum Enemy {
	Parachutist,
	Fairy,
	Bat,
}

var enemies_to_spawn := {Enemy.Parachutist: 1, Enemy.Bat: 0, Enemy.Fairy: 0}

var ui: GameUI = null

var level_data: LevelData = null
var level_started := false
var gold := 5
var hordes := []
var level_time := 0.0

var highscore := 0

onready var hordes_node := $Hordes as Node2D
onready var enemies_node := $Enemies as Node2D

func _ready() -> void:
	randomize()
	
	ui = game_ui_prefab.instance() as GameUI
	get_tree().get_root().call_deferred("add_child", ui)
	
	for horde in hordes_node.get_children():
		hordes.push_back(horde)
		
	var highscore_file := File.new()
	if highscore_file.file_exists("user://highscore.wd"):
		highscore_file.open("user://highscore.wd", File.READ)
		highscore = highscore_file.get_16()
		highscore_file.close()
	
	ui.set_highscore(highscore)
	
	
func _process(delta: float) -> void:
	if level_started:
		level_time += delta
		ui.set_timer_text(level_time)
		
	# Spawning rules
	if level_time > 30.0:
		enemies_to_spawn[Enemy.Bat] = 1
	if level_time > 60.0:
		enemies_to_spawn[Enemy.Fairy] = 1
		
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
		
	if Input.is_action_just_pressed("pause"):
		var pause_menu := pause_menu_prefab.instance() as Control
		get_tree().get_root().add_child(pause_menu)
		get_tree().paused = true
	

func start_level() -> void:
	for child in enemies_node.get_children():
		child.queue_free()

	level_time = 0.0
	ui.set_timer_text(level_time)
	gold = 8
	
	enemies_to_spawn[Enemy.Parachutist] = 1
	enemies_to_spawn[Enemy.Bat] = 0
	enemies_to_spawn[Enemy.Fairy] = 0

	ui.set_gold_count(8)
	ui.play_animation("start")
	ui.connect("animation_finished", self, "start_timer", [], CONNECT_ONESHOT)


func start_timer() -> void:
	level_started = true
	$TimerSpawnParachutist.set_wait_time(rand_range(3, 6))
	$TimerSpawnParachutist.start()
	$TimerSpawnBat.set_wait_time(rand_range(6, 8))
	$TimerSpawnBat.start()
	$TimerSpawnFairy.set_wait_time(rand_range(9, 12))
	$TimerSpawnFairy.start()


func get_random_horde() -> Area2D:
	var index := int(round(rand_range(0, len(hordes) - 1)))
	return hordes[index]
	
	
func get_closest_horde(to: Vector2) -> Area2D:
	var dists := []
	var dict := {}
	for horde in hordes:
		var this_dist: float = horde.get_position().distance_to(to)
		dists.push_back(this_dist)
		dict[this_dist] = horde
	
	return dict[dists.min()]
	
	
func lose_gold() -> void:
	if level_started:
		$SoundLoseGold.play()
		gold -= 1
		ui.set_gold_count(max(gold, 0))
		
		if gold <= 0:
			$Music.stop()
			$Player/SoundWalk.stop()
			$Player/SoundShootRight.stop()
			$Player/LightningBeam.hide()
			$TimerSpawnParachutist.stop()
			$TimerSpawnBat.stop()
			$TimerSpawnFairy.stop()
			level_started = false
			$Player.set_can_move(false)
			$Player.play_lose_animation()
			$SoundGameover.play()
			ui.play_animation("gameover")
			for enemy in enemies_node.get_children():
				enemy._die(false)
				
			if level_time > highscore:
				highscore = floor(level_time)
				ui.set_highscore(floor(level_time))
				var dir := Directory.new()
				if dir.file_exists("user://highscore.wd"):
					dir.remove("user://highscore.wd")
				var highscore_file := File.new()
				highscore_file.open("user://highscore.wd", File.WRITE)
				highscore_file.store_16(highscore)
				highscore_file.close()


func spawn_enemy(type: int, position_: Vector2) -> void:
	var enemy: KinematicBody2D
	match type:
		Enemy.Parachutist:
			enemy = enemy_prefab_parachutist.instance() as KinematicBody2D
		Enemy.Bat:
			enemy = enemy_prefab_bat.instance() as KinematicBody2D
		Enemy.Fairy:
			enemy = enemy_prefab_fairy.instance() as KinematicBody2D
			
	enemy.set_position(position_)
	enemies_node.add_child(enemy)


func _on_TimerStart_timeout() -> void:
	start_level()


func _on_TimerSpawnParachutist_timeout() -> void:
	if level_started:
		for _i in range(enemies_to_spawn[Enemy.Parachutist]):
			for _j in range(int(round(rand_range(1, 2)))):
				spawn_enemy(Enemy.Parachutist, Vector2(rand_range(10, 630), rand_range(-30, -20)))
				
		$TimerSpawnParachutist.set_wait_time(rand_range(3, 6))
	

func _on_TimerSpawnBat_timeout() -> void:
	if level_started:
		for _i in range(enemies_to_spawn[Enemy.Bat]):
			for _j in range(int(round(rand_range(1, 3)))):
				spawn_enemy(Enemy.Bat, Vector2(rand_range(-30, -20) if randf() > 0.5 else rand_range(660, 670), rand_range(10, 240)))
				
		$TimerSpawnBat.set_wait_time(rand_range(6, 8))


func _on_TimerSpawnFairy_timeout() -> void:
	if level_started:
		for _i in range(enemies_to_spawn[Enemy.Fairy]):
			for _j in range(int(round(rand_range(1, 2)))):
				spawn_enemy(Enemy.Fairy, Vector2(rand_range(-30, -20) if randf() > 0.5 else rand_range(660, 670), rand_range(10, 240)))
				
		$TimerSpawnFairy.set_wait_time(rand_range(9, 12))
