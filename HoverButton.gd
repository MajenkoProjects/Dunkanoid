extends Button

class_name HoverButton

@export var NormalVariant : String = ""
@export var HoverVariant : String = ""

func _ready() -> void:
	mouse_entered.connect(_hover_start)
	mouse_exited.connect(_hover_end)

func _hover_start() -> void:
	theme_type_variation = HoverVariant
	
func _hover_end() -> void:
	theme_type_variation = NormalVariant
