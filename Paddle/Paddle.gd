extends StaticBody2D
class_name Paddle

signal effect_finished(effect : int)
signal effect_started(effect : int)

enum {
	PADDLE_NORMAL,
	PADDLE_CAPTURE,
	PADDLE_SMALL,
	PADDLE_LARGE,
	PADDLE_LAZER
}

var mode : int = PADDLE_NORMAL
var running_effect : int = PADDLE_NORMAL

var width : int :
	get:
		return $CollisionShape2D.shape.height

func hit() -> void:
	pass

func _switch_effect(effect : int, time : int = 0) -> void:
	if mode != PADDLE_NORMAL:
		effect_finished.emit(mode)
	mode = effect
	if mode != PADDLE_NORMAL:
		effect_started.emit(mode)
		if time > 0:
			$EffectTimer.start(time)
	else:
		$EffectTimer.stop()

func big() -> void:
	$Normal.visible = false
	$Small.visible = false
	$Big.visible = true
	$CollisionShape2D.shape.height = 40
	$GrowSound.play()
	_switch_effect(PADDLE_LARGE, 30)

func small() -> void:
	$Normal.visible = false
	$Small.visible = true
	$Big.visible = false
	$CollisionShape2D.shape.height = 24
	$ShrinkSound.play()
	_switch_effect(PADDLE_SMALL, 30)

func normal() -> void:
	$Normal.visible = true
	$Small.visible = false
	$Big.visible = false
	$CollisionShape2D.shape.height = 32
	_switch_effect(PADDLE_NORMAL)
	
func capture() -> void:
	$Normal.visible = true
	$Small.visible = false
	$Big.visible = false
	$CollisionShape2D.shape.height = 32
	_switch_effect(PADDLE_CAPTURE, 15)
	
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

func is_lazer() -> bool:
	return mode == PADDLE_LAZER
