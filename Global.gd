extends Node

const INT64_MAX = (1 << 63) - 1 # 9223372036854775807

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

var _loading : bool = false

func _ready() -> void:
	_loading = true
	if FileAccess.file_exists("user://data.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://data.json"))
		highscore = data.get("highscore", 0)
		relative_mouse = data.get("relative_mouse", true)
		music_volume = data.get("music_volume", AudioServer.get_bus_volume_db(1))
		effects_volume = data.get("effects_volume", AudioServer.get_bus_volume_db(2))
		best_times = data.get("best_times", {})
	else:
		highscore = 0
		relative_mouse = true
		music_volume = AudioServer.get_bus_volume_db(1)	
		effects_volume = AudioServer.get_bus_volume_db(2)	
		best_times = {}
	_loading = false

func _save() -> void:
	if _loading:
		return
	var data : Dictionary = {
		"highscore": highscore,
		"relative_mouse": relative_mouse,
		"music_volume": music_volume,
		"effects_volume": effects_volume,
		"best_times": best_times
	}
	var f = FileAccess.open("user://data.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()

func get_best_time(level : String) -> int:
	return best_times.get(level, INT64_MAX)

func set_best_time(level : String, time : int) -> void:
	best_times[level] = time
	_save()
