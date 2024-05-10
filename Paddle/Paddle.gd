extends StaticBody2D
class_name Paddle

signal effect_finished(effect : int)
signal effect_started(effect : int)

enum {
	PADDLE_NORMAL,
	PADDLE_CAPTURE,
	PADDLE_SMALL,
	PADDLE_LARGE,
	PADDLE_LASER
}

var mode : int = PADDLE_NORMAL
var running_effect : int = PADDLE_NORMAL

var width : int :
	get:
		return $CollisionShape2D.shape.height

func hit(_power : int) -> void:
	pass

func _switch_effect(effect : int, time : int = 0) -> void:
	if mode != effect: 
		if mode != PADDLE_NORMAL:
			effect_finished.emit(mode)
		if effect != PADDLE_NORMAL:
			effect_started.emit(mode)
			
	mode = effect
	if time > 0:
		$EffectTimer.start(time)
	else:
		$EffectTimer.stop()

func show_paddle(paddle : Node2D) -> void:
	$Normal.visible = true if paddle == $Normal else false
	$Small.visible = true if paddle == $Small else false
	$Big.visible = true if paddle == $Big else false
	$Magnet.visible = true if paddle == $Magnet else false
	$Laser.visible = true if paddle == $Laser else false

	$CollisionShape2D.shape.height = 32
	if paddle == $Big: $CollisionShape2D.shape.height = 40
	if paddle == $Small: $CollisionShape2D.shape.height = 24	 

	
	
func big() -> void:
	show_paddle($Big)
	$GrowSound.play()
	_switch_effect(PADDLE_LARGE, Global.get_effect_time())

func small() -> void:
	show_paddle($Small)
	$CollisionShape2D.shape.height = 24
	$ShrinkSound.play()
	_switch_effect(PADDLE_SMALL, Global.get_effect_time())

func normal() -> void:
	show_paddle($Normal)
	$CollisionShape2D.shape.height = 32
	_switch_effect(PADDLE_NORMAL)

func laser() -> void:
	show_paddle($Laser)
	$CollisionShape2D.shape.height = 32
	_switch_effect(PADDLE_LASER, Global.get_effect_time())
	
func capture() -> void:
	show_paddle($Magnet)
	$CollisionShape2D.shape.height = 32
	_switch_effect(PADDLE_CAPTURE, Global.get_effect_time())
	
func _on_effect_timer_timeout() -> void:
	normal()

func is_big() -> bool:
	return mode == PADDLE_LARGE

func is_small() -> bool:
	return mode == PADDLE_SMALL

func is_normal() -> bool:
	return mode == PADDLE_NORMAL

func is_capture() -> bool:
	return mode == PADDLE_CAPTURE

func is_laser() -> bool:
	return mode == PADDLE_LASER
