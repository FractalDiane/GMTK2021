extends Node2D

const horde_prefab := preload("res://prefabs/horde.tscn")
const game_ui_prefab := preload("res://prefabs/game_ui.tscn")

const enemy_prefab_parachutist := preload("res://prefabs/enemies/enemy_parachutist.tscn")
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

onready var hordes_node := $Hordes as Node2D
onready var enemies_node := $Enemies as Node2D

func _ready() -> void:
	randomize()
	
	ui = game_ui_prefab.instance() as GameUI
	get_tree().get_root().call_deferred("add_child", ui)
	
	
func _process(delta: float) -> void:
	if level_started:
		level_time += delta
		ui.set_timer_text(level_time)
		
	# Spawning rules
	if level_time > 30.0:
		enemies_to_spawn[Enemy.Bat] = 1
	if level_time > 60.0:
		enemies_to_spawn[Enemy.Fairy] = 1
	

func start_level_pre(level_data_: LevelData) -> void:
	level_data = level_data_
	$AnimationPlayer.play("start_level")


func start_level() -> void:
	for child in hordes_node.get_children():
		child.queue_free()
	for child in enemies_node.get_children():
		child.queue_free()
		
	hordes.clear()
	for posx in level_data.horde_x_positions:
		var horde := horde_prefab.instance() as Area2D
		horde.set_position(Vector2(posx, 304))
		hordes_node.add_child(horde)
		hordes.push_back(horde)

	level_time = 0.0
	ui.set_timer_text(level_time)
	gold = level_data.starting_gold

	ui.set_gold_count(level_data.starting_gold)
	ui.play_animation("start")
	ui.connect("animation_finished", self, "start_timer")


func start_timer() -> void:
	level_started = true
	$TimerSpawnParachutist.set_wait_time(rand_range(3, 6))
	$TimerSpawnParachutist.start()
	$TimerSpawnBat.set_wait_time(rand_range(6, 8))
	$TimerSpawnBat.start()
	$TimerSpawnFairy.set_wait_time(rand_range(9, 12))
	$TimerSpawnFairy.start()

	#spawn_enemy(Enemy.Fairy, Vector2(30, 20))


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
	gold -= 1
	ui.set_gold_count(gold)


func spawn_enemy(type: int, position_: Vector2) -> void:
	var enemy: KinematicBody2D
	match type:
		Enemy.Parachutist:
			enemy = enemy_prefab_parachutist.instance() as KinematicBody2D
		Enemy.Fairy:
			enemy = enemy_prefab_fairy.instance() as KinematicBody2D
			
	enemy.set_position(position_)
	enemies_node.add_child(enemy)


func _on_TimerStart_timeout() -> void:
	start_level_pre(level_data_test)


func _on_TimerSpawnParachutist_timeout() -> void:
	for i in range(enemies_to_spawn[Enemy.Parachutist]):
		for j in range(int(round(rand_range(1, 3)))):
			spawn_enemy(Enemy.Parachutist, Vector2(rand_range(10, 630), -30))
			
	$TimerSpawnParachutist.set_wait_time(rand_range(3, 6))
	

func _on_TimerSpawnBat_timeout() -> void:
	pass # Replace with function body.


func _on_TimerSpawnFairy_timeout() -> void:
	pass # Replace with function body.

