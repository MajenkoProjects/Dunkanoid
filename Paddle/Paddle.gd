extends StaticBody2D
class_name Paddle

var width : int :
	get:
		return $CollisionShape2D.shape.height

func hit() -> void:
	pass

func big() -> void:
	$Normal.visible = false
	$Small.visible = false
	$Big.visible = true
	$CollisionShape2D.shape.height = 40
	$EffectTimer.start(30)
	$GrowSound.play()
	pass

func small() -> void:
	$Normal.visible = false
	$Small.visible = true
	$Big.visible = false
	$CollisionShape2D.shape.height = 24
	$EffectTimer.start(30)
	$ShrinkSound.play()
	pass

func normal() -> void:
	$Normal.visible = true
	$Small.visible = false
	$Big.visible = false
	$CollisionShape2D.shape.height = 32
	pass

func _on_effect_timer_timeout() -> void:
	normal()
