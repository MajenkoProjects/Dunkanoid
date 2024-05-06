extends Node

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

var volume : int :
	set(x):
		volume = x
		AudioServer.set_bus_volume_db(0, volume)
		_save()

var _loading : bool = false

func _ready() -> void:
	_loading = true
	if FileAccess.file_exists("user://data.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://data.json"))
		highscore = data.get("highscore", 0)
		relative_mouse = data.get("relative_mouse", true)
		volume = data.get("volume", AudioServer.get_bus_volume_db(0))
	else:
		highscore = 0
		relative_mouse = true
		volume = AudioServer.get_bus_volume_db(0)	
	_loading = false

func _save() -> void:
	if _loading:
		return
	var data : Dictionary = {
		"highscore": highscore,
		"relative_mouse": relative_mouse,
		"volume": volume
	}
	var f = FileAccess.open("user://data.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()
