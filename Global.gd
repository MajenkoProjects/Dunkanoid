extends Node

const INT64_MAX = (1 << 63) - 1 # 9223372036854775807

const _settings : Array[String] = [
		"highscore", "relative_mouse",
		"music_volume", "effects_volume",
		"best_times", "upgrade_tokens",
		"effect_time", "laser_power",
		"extra_lives", "powerup_percent",
		"ball_split", "laser_autofire"
]

var score : int = 0 :
	set(x):
		score = x
		EventBus.update_score.emit(score)
		if score > highscore:
			highscore = score

var highscore : int = 0 :
	set(x):
		highscore = x
		EventBus.update_highscore.emit(highscore)
		_save()

var relative_mouse : bool = true :
	set(x):
		relative_mouse = x
		_save()

var music_volume : int :
	set(x):
		music_volume = x
		AudioServer.set_bus_volume_db(1, music_volume)
		_save()

var effects_volume : int :
	set(x):
		effects_volume = x
		AudioServer.set_bus_volume_db(2, effects_volume)
		_save()

var best_times : Dictionary

var upgrade_tokens : int = 0 :
	set(x):
		upgrade_tokens = x
		EventBus.upgrade_tokens_updated.emit(upgrade_tokens)
		_save()

var effect_time : int = 0 :
	set(x):
		effect_time = x
		_save()

var laser_power : int = 0 :
	set(x):
		laser_power = x
		_save()

var extra_lives : int = 0 :
	set(x):
		extra_lives = x
		_save()

var powerup_percent : int = 0 :
	set(x):
		powerup_percent = x
		_save()

var ball_split : int = 0 :
	set(x):
		ball_split = x
		_save()
		
var laser_autofire : int = 0 :
	set(x):
		laser_autofire = x
		_save()


# Textures and other resources
var Backgrounds : Dictionary = {}
var Bricks : Dictionary = {
	"blank": preload("res://Brick/BlankBrick.png"),
	"base": preload("res://Brick/BaseBrick.png"),
	"shiny": preload("res://Brick/ShinyBrick.png"),
	"invul": preload("res://Brick/InvulBrick.png")
}

var start_level : String = "DUNKANOID"
var _loading : bool = false

var MainTheme = preload("res://MainTheme.tres")

func _ready() -> void:
	_loading = true
	load_backgrounds()
	if FileAccess.file_exists("user://data.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://data.json"))
		for s in _settings:
			if data.has(s):
				set(s, data.get(s))
	else:
		highscore = 0
		relative_mouse = true
		music_volume = int(AudioServer.get_bus_volume_db(1))
		effects_volume = int(AudioServer.get_bus_volume_db(2))
		best_times = {}
		upgrade_tokens = 0
		effect_time = 0
		laser_power = 0
		extra_lives = 0
		powerup_percent = 0
		ball_split = 0
		laser_autofire = 0
		
	_loading = false

func _save() -> void:
	if _loading:
		return
	var data : Dictionary = {}
	for s in _settings:
		data[s] = get(s)
	var f = FileAccess.open("user://data.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()

func get_best_time(level : String) -> int:
	return best_times.get(level, INT64_MAX)

func set_best_time(level : String, time : int) -> void:
	best_times[level] = time
	_save()

func reset_best_times() -> void:
	best_times.clear()
	_save()


func get_effect_time() -> int:
	return 5 + (effect_time * 5)

func get_laser_power() -> int:
	return laser_power + 1

func get_lives() -> int:
	return extra_lives + 3

func get_powerup_percent() -> float:
	return 0.98 - (powerup_percent * 0.02)

func get_num_balls() -> int:
	return ball_split + 2

func format_effect_time() -> String:
	return "%d s" % get_effect_time()

func format_laser_power() -> String:
	var p = get_laser_power()
	if p == 1:
		return "1 hit"
	return "%d hits" % p

func format_extra_lives() -> String:
	return "%d lives" % get_lives()

func format_powerup_percent() -> String:
	return "%d%%" % int((1 - get_powerup_percent()) * 100)

func format_ball_split() -> String:
	return "%d balls" % get_num_balls()



func load_backgrounds() -> void:
	for bg in Backgrounds.values():
		bg.free()
	Backgrounds.clear()
	if DirAccess.dir_exists_absolute("user://Backgrounds"):
		for file in DirAccess.get_files_at("user://Backgrounds"):
			if file.ends_with(".png") or file.ends_with(".jpg"):
				var bgname = file.left(-4)
				Backgrounds[bgname] = load("user://Backgrounds/%s" % file)
	for file in DirAccess.get_files_at("res://Backgrounds"):
		if file.ends_with(".png.import") or file.ends_with(".jpg.import"):
			var bgname = file.left(-11)
			if not Backgrounds.has(bgname):
				Backgrounds[bgname] = load("res://Backgrounds/%s" % file.left(-7))
