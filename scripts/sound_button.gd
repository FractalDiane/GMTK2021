extends TextureButton

const sound_hover := preload("res://audio/hover.ogg")
const sound_click := preload("res://audio/click_new.ogg")

func _ready() -> void:
	var player_hover := AudioStreamPlayer.new()
	player_hover.stream = sound_hover
	player_hover.volume_db = -8
	add_child(player_hover)
	var player_click := AudioStreamPlayer.new()
	player_click.stream = sound_click
	player_click.volume_db = -4
	add_child(player_click)
	connect("mouse_entered", player_hover, "play")
	connect("pressed", player_click, "play")
