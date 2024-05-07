extends Node

class_name RunTimer

var start_ms : int = 0
var accumulated_pause_time : int = 0
var pause_time : int = 0

var paused : bool = false

var elapsed_time : int : 
	get:
		if paused:
			var elapsed = Time.get_ticks_msec() - pause_time
			return Time.get_ticks_msec() - start_ms - accumulated_pause_time - elapsed
		else:
			return Time.get_ticks_msec() - start_ms - accumulated_pause_time

func _ready() -> void:
	EventBus.paused.connect(_on_pause)
	EventBus.unpaused.connect(_on_unpause)

func _on_timeout() -> void:
	print(Time.get_ticks_msec())

func _on_pause() -> void:
	paused = true
	pause_time = Time.get_ticks_msec()

func pause() -> void:
	paused = true
	pause_time = Time.get_ticks_msec()

func unpause() -> void:
	paused = false
	var elapsed = Time.get_ticks_msec() - pause_time
	accumulated_pause_time += elapsed	

func _on_unpause() -> void:
	paused = false
	var elapsed = Time.get_ticks_msec() - pause_time
	accumulated_pause_time += elapsed

func start() -> void:
	start_ms = Time.get_ticks_msec()
	accumulated_pause_time = 0
	paused = false


