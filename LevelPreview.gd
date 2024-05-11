@tool
extends TextureRect

class_name LevelPreview

@export var LevelName : String = "DUNKANOID" : 
	set(x):
		LevelName = x
		update_preview()

func _ready() -> void:
	update_preview()

func update_preview() -> void:
	var level = Level.new()
	level.load_level(LevelName)
	add_child(level)
	await RenderingServer.frame_post_draw

	var img = level.get_texture().get_image()
	var itex = ImageTexture.create_from_image(img)
	texture = itex
#	remove_child(level)
#	sv.queue_free()
#	level.call_deferred("queue_free")
	queue_redraw()
