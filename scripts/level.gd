extends Node2D

const horde_prefab := preload("res://prefabs/horde.tscn")
const game_ui_prefab := preload("res://prefabs/game_ui.tscn")

const enemy_prefab_fairy := preload("res://prefabs/enemies/enemy_fairy.tscn")

export(Resource) var level_data_test

enum Enemy {
	Parachutist,
	Fairy,
}

var ui: GameUI = null

var level_started := false

var hordes := []

onready var timer_level := $TimerLevel as Timer

func _ready() -> void:
	randomize()
	
	ui = game_ui_prefab.instance() as GameUI
	get_tree().get_root().call_deferred("add_child", ui)
	
	
func _process(delta: float) -> void:
	if level_started:
		ui.set_timer_text(timer_level.get_time_left())
	

func start_level(level_data: LevelData) -> void:
	hordes.clear()
	for posx in level_data.horde_x_positions:
		var horde := horde_prefab.instance() as Area2D
		horde.set_position(Vector2(posx, 304))
		add_child(horde)
		hordes.push_back(horde)

	timer_level.set_wait_time(level_data.time)

	ui.set_timer_text(level_data.time)
	ui.play_animation("start")
	ui.connect("animation_finished", self, "start_timer")


func start_timer() -> void:
	timer_level.start()
	level_started = true

	spawn_enemy(Enemy.Fairy, Vector2(30, 20))


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


func spawn_enemy(type: int, position_: Vector2) -> void:
	var enemy: KinematicBody2D
	match type:
		Enemy.Fairy:
			enemy = enemy_prefab_fairy.instance() as KinematicBody2D
			
	enemy.set_position(position_)
	add_child(enemy)


func _on_TimerStart_timeout() -> void:
	start_level(level_data_test)
