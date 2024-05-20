extends Node

var MusicPlayer : AudioStreamPlayer
var JinglePlayer : AudioStreamPlayer

enum {
	MUSIC_INTRO,
	MUSIC_GAME,
	MUSIC_GAME_OVER,
	MUSIC_NONE
}

enum {
	JINGLE_LEVEL_START,
	JINGLE_LEVEL_WON,
	JINGLE_GAME_OVER
}

signal jingle_finished(type : int)

var music : int = MUSIC_NONE
var pausepos : float = 0

var MP3 : Dictionary = {
	"Through The Crystal": preload("res://Music/Through The Crystal - Jeremy Blake.mp3"),
	"Powerup": preload("res://Music/Powerup! - Jeremy Blake.mp3"),
	"Absolutely Nothing" : preload("res://Music/Absolutely Nothing - Jeremy Blake.mp3"),
	"I'll Remember You": preload("res://Music/I'll Remember You - Jeremy Blake.mp3")
}

var JingleFileStart = preload("res://Sounds/Start.wav")
var JingleFileWin = preload("res://Sounds/Win.wav")
var JingleFileGameOver = preload("res://Sounds/GameOver.wav")

var jingle_playing : bool = false
var jingle_number : int = 0

var tween = null

func _ready() -> void:
	pass

func initialize() -> void:
	MusicPlayer = AudioStreamPlayer.new();
	MusicPlayer.bus = "Music"
	MusicPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(MusicPlayer)
#	MusicPlayer.stream = MP3["Through The Crystal"]
#	MusicPlayer.play()
#	music = MUSIC_INTRO

	JinglePlayer = AudioStreamPlayer.new();
	JinglePlayer.bus = "Music"
	JinglePlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	JinglePlayer.finished.connect(_jingle_done)
	add_child(JinglePlayer)


func fade_up(time : int = 1) -> void:
	if MusicPlayer.volume_db < 0:
		if tween != null:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(MusicPlayer, "volume_db", 0, time)

func fade_down(time : int = 1) -> void:
	if MusicPlayer.volume_db > -80:
		if tween != null:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(MusicPlayer, "volume_db", -80, time)

func play_game() -> void:
	fade_up()
	if music == MUSIC_GAME:
		return
	if jingle_playing:
		pausepos = 0
	else:
		MusicPlayer.stream = MP3["Powerup"]
		MusicPlayer.play()
	music = MUSIC_GAME

func play_intro() -> void:
	fade_up()
	if music == MUSIC_INTRO:
		return
	if jingle_playing:
		pausepos = 0
	else:
		MusicPlayer.stream = MP3["Through The Crystal"]
		MusicPlayer.play()
	music = MUSIC_INTRO

func play_game_over() -> void:
	fade_up()
	if music == MUSIC_GAME_OVER:
		return
	if jingle_playing:
		pausepos = 0
	else:
		MusicPlayer.stream = MP3["I'll Remember You"]
		MusicPlayer.play()
	music = MUSIC_GAME_OVER
	
func pause() -> void:
	pausepos = MusicPlayer.get_playback_position()
	MusicPlayer.stop()

func resume() -> void:
	MusicPlayer.play(pausepos)

func jingle(item : int) -> void:
	fade_down()
#	MusicPlayer.volume_db = 0
	jingle_number = item
#	pause()
	match item:
		JINGLE_LEVEL_START:
			JinglePlayer.stream = JingleFileStart
			JinglePlayer.play()
		JINGLE_LEVEL_WON:
			JinglePlayer.stream = JingleFileWin
			JinglePlayer.play()
		JINGLE_GAME_OVER:
			JinglePlayer.stream = JingleFileGameOver
			JinglePlayer.play()
	jingle_playing = true
	pass

func _jingle_done() -> void:
	fade_up()
	#match music:
		#MUSIC_INTRO:
			#MusicPlayer.stream = MP3["Through The Crystal"]
		#MUSIC_GAME:
			#MusicPlayer.stream = MP3["Powerup"]
		#MUSIC_GAME_OVER:
			#MusicPlayer.stream = MP3["I'll Remember You"]
	#resume()
	jingle_playing = false
	jingle_finished.emit(jingle_number)
