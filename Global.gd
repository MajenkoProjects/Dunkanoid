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

func _ready() -> void:
	if FileAccess.file_exists("user://data.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://data.json"))
		highscore = data.get("highscore", 0)

func _save() -> void:
	var data : Dictionary = {
		"highscore": highscore
	}
	var f = FileAccess.open("user://data.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()
