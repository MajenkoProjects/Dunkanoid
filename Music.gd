extends Node

var MusicPlayer : AudioStreamPlayer

enum {
	MUSIC_INTRO,
	MUSIC_GAME,
	MUSIC_GAME_OVER
}

enum {
	JINGLE_LEVEL_START,
	JINGLE_LEVEL_WON,
	JINGLE_GAME_OVER
}

signal jingle_finished(type : int)

var music : int = MUSIC_INTRO
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


func _ready() -> void:
	MusicPlayer = AudioStreamPlayer.new();
	MusicPlayer.bus = "Music"
	MusicPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(MusicPlayer)
	MusicPlayer.stream = MP3["Through The Crystal"]
	MusicPlayer.play()
	music = MUSIC_INTRO

func play_game() -> void:
	if music == MUSIC_GAME:
		return
	if jingle_playing:
		pausepos = 0
	else:
		MusicPlayer.stream = MP3["Powerup"]
		MusicPlayer.play()
	music = MUSIC_GAME

func play_intro() -> void:
	if music == MUSIC_INTRO:
		return
	if jingle_playing:
		pausepos = 0
	else:
		MusicPlayer.stream = MP3["Through The Crystal"]
		MusicPlayer.play()
	music = MUSIC_INTRO

func play_game_over() -> void:
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
	jingle_number = item
	MusicPlayer.finished.connect(_jingle_done)
	pause()
	match item:
		JINGLE_LEVEL_START:
			MusicPlayer.stream = JingleFileStart
			MusicPlayer.play()
		JINGLE_LEVEL_WON:
			MusicPlayer.stream = JingleFileWin
			MusicPlayer.play()
		JINGLE_GAME_OVER:
			MusicPlayer.stream = JingleFileGameOver
			MusicPlayer.play()
	jingle_playing = true
	pass

func _jingle_done() -> void:
	MusicPlayer.finished.disconnect(_jingle_done)
	match music:
		MUSIC_INTRO:
			MusicPlayer.stream = MP3["Through The Crystal"]
		MUSIC_GAME:
			MusicPlayer.stream = MP3["Powerup"]
		MUSIC_GAME_OVER:
			MusicPlayer.stream = MP3["I'll Remember You"]
	resume()
	jingle_playing = false
	jingle_finished.emit(jingle_number)
