extends Node2D

class_name Pipes

signal door_opened(door : int)
signal door_closed(door : int)

enum {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

func open_door(door : int) -> void:
	match door:
		TOP_LEFT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($TopDoor1L, "position", $TopDoor1L.get_meta("open"), 1)
			tween.tween_property($TopDoor1R, "position", $TopDoor1R.get_meta("open"), 1)
			tween.finished.connect(_top_left_opened)
		TOP_RIGHT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($TopDoor2L, "position", $TopDoor2L.get_meta("open"), 1)
			tween.tween_property($TopDoor2R, "position", $TopDoor2R.get_meta("open"), 1)
			tween.finished.connect(_top_right_opened)
		BOTTOM_LEFT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($LeftDoor, "position", $LeftDoor.get_meta("open"), 1)
			tween.finished.connect(_bottom_left_opened)
		BOTTOM_RIGHT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($RightDoor, "position", $RightDoor.get_meta("open"), 1)
			tween.finished.connect(_bottom_right_opened)

func _top_left_opened() -> void:
	door_opened.emit(TOP_LEFT)

func _top_right_opened() -> void:
	door_opened.emit(TOP_RIGHT)

func _bottom_left_opened() -> void:
	door_opened.emit(BOTTOM_LEFT)

func _bottom_right_opened() -> void:
	door_opened.emit(BOTTOM_LEFT)
	


func close_door(door : int) -> void:
	match door:
		TOP_LEFT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($TopDoor1L, "position", $TopDoor1L.get_meta("closed"), 1)
			tween.tween_property($TopDoor1R, "position", $TopDoor1R.get_meta("closed"), 1)
			tween.finished.connect(_top_left_closed)
		TOP_RIGHT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($TopDoor2L, "position", $TopDoor2L.get_meta("closed"), 1)
			tween.tween_property($TopDoor2R, "position", $TopDoor2R.get_meta("closed"), 1)
			tween.finished.connect(_top_right_closed)
		BOTTOM_LEFT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($LeftDoor, "position", $LeftDoor.get_meta("closed"), 1)
			tween.finished.connect(_bottom_left_closed)
		BOTTOM_RIGHT:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property($RightDoor, "position", $RightDoor.get_meta("closed"), 1)
			tween.finished.connect(_bottom_right_closed)

func _top_left_closed() -> void:
	door_closed.emit(TOP_LEFT)

func _top_right_closed() -> void:
	door_closed.emit(TOP_RIGHT)

func _bottom_left_closed() -> void:
	door_closed.emit(BOTTOM_LEFT)

func _bottom_right_closed() -> void:
	door_closed.emit(BOTTOM_LEFT)
