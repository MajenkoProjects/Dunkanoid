extends Button

func _ready() -> void:
	visible = not OS.has_feature("web")
